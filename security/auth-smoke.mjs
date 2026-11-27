import assert from 'node:assert/strict';
import { randomBytes, randomUUID } from 'node:crypto';
import { readFileSync } from 'node:fs';

if (process.env.FOCUSNFLOW_LIVE_AUTH_TEST !== 'yes') {
  throw new Error('Set FOCUSNFLOW_LIVE_AUTH_TEST=yes to run the disposable live-account check.');
}
const config = JSON.parse(readFileSync(new URL('../android/app/google-services.json', import.meta.url)));
assert.equal(config.project_info.project_id, 'focusnflow-myles-eziz');
const client = config.client.find(c => c.client_info.android_client_info.package_name === 'com.example.focusnflow');
assert.ok(client);
const key = client.api_key[0].current_key;
const email = `auth-check-${randomUUID()}@example.invalid`;
const password = randomBytes(24).toString('base64url');
const results = { project: config.project_info.project_id, transport: 'live Firebase Auth REST', checks: [], cleanup: false };

async function request(path, body, origin = 'https://identitytoolkit.googleapis.com/v1') {
  const response = await fetch(`${origin}/${path}?key=${key}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
    signal: AbortSignal.timeout(20000),
  });
  return { ok: response.ok, data: await response.json() };
}

let created;
try {
  const weak = await request('accounts:signUp', { email, password: 'short', returnSecureToken: true });
  if (weak.ok) {
    created = weak.data;
    throw new Error('Unexpected weak-password acceptance; cleaning up the disposable account.');
  }
  assert.ok(weak.data.error?.message?.startsWith('WEAK_PASSWORD'));
  results.checks.push('five-character signup password rejected');

  const signup = await request('accounts:signUp', { email, password, returnSecureToken: true });
  assert.equal(signup.ok, true, `Signup failed: ${signup.data.error?.message?.split(' : ')[0] ?? 'unknown'}`);
  created = signup.data;
  assert.equal(created.email, email);
  assert.ok(created.localId && created.idToken);
  results.checks.push('disposable email/password account created');

  const denied = await request('accounts:signInWithPassword', { email, password: `${password}-wrong`, returnSecureToken: true });
  assert.equal(denied.ok, false);
  assert.ok(['INVALID_LOGIN_CREDENTIALS', 'INVALID_PASSWORD'].includes(denied.data.error?.message));
  results.checks.push('wrong password rejected');

  const signedIn = await request('accounts:signInWithPassword', { email, password, returnSecureToken: true });
  assert.equal(signedIn.ok, true);
  assert.equal(signedIn.data.localId, created.localId);
  results.checks.push('correct password returned the same identity');

  const refreshed = await request('token', { grant_type: 'refresh_token', refresh_token: signedIn.data.refreshToken }, 'https://securetoken.googleapis.com/v1');
  assert.equal(refreshed.ok, true);
  assert.equal(refreshed.data.user_id, created.localId);
  results.checks.push('refresh token returned the same identity');
} finally {
  if (created?.idToken) {
    const deleted = await request('accounts:delete', { idToken: created.idToken });
    assert.equal(deleted.ok, true, 'Disposable account cleanup failed; inspect the private run before retrying.');
    results.cleanup = true;
  }
}
const removed = await request('accounts:signInWithPassword', { email, password, returnSecureToken: true });
assert.equal(removed.ok, false, 'Deleted disposable account unexpectedly signed in.');
assert.ok(['INVALID_LOGIN_CREDENTIALS', 'EMAIL_NOT_FOUND'].includes(removed.data.error?.message));
results.checks.push('deleted disposable account cannot sign in');
console.log(JSON.stringify(results, null, 2));
