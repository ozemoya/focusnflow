import { readFileSync } from 'node:fs';
import { after, before, beforeEach, test } from 'node:test';
import assert from 'node:assert/strict';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { collection, deleteDoc, doc, getDoc, getDocs, serverTimestamp, setDoc, Timestamp, updateDoc } from 'firebase/firestore';

let env;
before(async () => {
  assert.equal(process.env.GCLOUD_PROJECT, 'demo-focusnflow');
  env = await initializeTestEnvironment({
    projectId: 'demo-focusnflow',
    firestore: { host: '127.0.0.1', port: 8185, rules: readFileSync('../firestore.rules', 'utf8') },
  });
});
beforeEach(async () => env.clearFirestore());
after(async () => env?.cleanup());

const profile = (changes = {}) => ({
  displayName: 'Test Student', reminders: false,
  createdAt: serverTimestamp(), updatedAt: serverTimestamp(), ...changes,
});
const db = (uid = 'alice') => env.authenticatedContext(uid).firestore();

test('owner creates, reads and updates a private profile', async () => {
  const ref = doc(db(), 'profiles/alice');
  await assertSucceeds(setDoc(ref, profile()));
  await assertSucceeds(updateDoc(ref, { displayName: 'New name', reminders: true, updatedAt: serverTimestamp() }));
  const snapshot = await assertSucceeds(getDoc(ref));
  assert.equal(snapshot.data().displayName, 'New name');
  assert.equal(snapshot.data().reminders, true);
});

test('anonymous clients cannot read or write profiles', async () => {
  const ref = doc(env.unauthenticatedContext().firestore(), 'profiles/alice');
  await assertFails(getDoc(ref));
  await assertFails(setDoc(ref, profile()));
});

test('another signed-in user cannot read, create, update or delete a profile', async () => {
  await setDoc(doc(db(), 'profiles/alice'), profile());
  const other = doc(db('bob'), 'profiles/alice');
  await assertFails(getDoc(other));
  await assertFails(setDoc(doc(db('bob'), 'profiles/charlie'), profile()));
  await assertFails(updateDoc(other, { reminders: true, updatedAt: serverTimestamp() }));
  await assertFails(deleteDoc(other));
});

test('owner cannot list profiles, inject roles or change creation time', async () => {
  const store = db();
  const ref = doc(store, 'profiles/alice');
  await assertFails(setDoc(ref, profile({ role: 'admin' })));
  await setDoc(ref, profile());
  await assertFails(getDocs(collection(store, 'profiles')));
  await assertFails(updateDoc(ref, { role: 'admin', updatedAt: serverTimestamp() }));
  await assertFails(updateDoc(ref, { createdAt: Timestamp.fromMillis(0), updatedAt: serverTimestamp() }));
  await assertFails(deleteDoc(ref));
});

test('display name accepts 1 and 80 characters and rejects empty, blank and oversized input', async () => {
  const ref = doc(db(), 'profiles/alice');
  await assertSucceeds(setDoc(ref, profile({ displayName: 'A' })));
  await assertSucceeds(updateDoc(ref, { displayName: 'a'.repeat(80), updatedAt: serverTimestamp() }));
  for (const displayName of ['', '   ', 'a'.repeat(81), 42]) {
    await assertFails(updateDoc(ref, { displayName, updatedAt: serverTimestamp() }));
  }
});

test('missing fields, wrong preference types and client timestamps are rejected', async () => {
  const ref = doc(db(), 'profiles/alice');
  const missing = profile();
  delete missing.displayName;
  await assertFails(setDoc(ref, missing));
  await assertFails(setDoc(ref, profile({ reminders: 'yes' })));
  await assertFails(setDoc(ref, profile({ updatedAt: Timestamp.fromMillis(0) })));
  await assertFails(setDoc(ref, profile({ createdAt: Timestamp.fromMillis(0) })));
});

test('unimplemented collections and nested profile records remain denied', async () => {
  const store = db();
  for (const path of ['rooms/demo', 'groups/demo', 'sessions/demo', 'profiles/alice/private/demo']) {
    await assertFails(getDoc(doc(store, path)));
    await assertFails(setDoc(doc(store, path), { owner: 'alice' }));
  }
});
