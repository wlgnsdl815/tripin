/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require('firebase-admin');
const functions = require('firebase-functions');
// const auth = require('firebase-auth');

// 키 경로설정
var serviceAccount = require("./sfac-tripin-firebase-adminsdk-kanz8-2cd2c446bc.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.addTimestamp = functions.https.onCall((data, context) => {return admin.firestore.Timestamp.now();})

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.createCustomToken = onRequest(async (request, response) => {
  const user = request.body;
  console.log("Received user:", user);
  
  const uid = `kakao:${user.kakaoId}`;
  const updateParams = {
    email: user.kakaoEmail,
    photoURL: user.kakaoPhotoURL,
    displayName: user.kakaoNickName,
  }
  
  console.log('uid:', uid);
  try {
    console.log('Generated UID:', uid);
    await admin.auth().updateUser(uid, updateParams);
} catch (e) {
    console.error("Error updating user:", e);
    updateParams['uid'] = uid;
    try {
        await admin.auth().createUser(updateParams);
    } catch (createError) {
        console.error("Error creating user:", createError);
    }
}


  const token = await admin.auth().createCustomToken(uid);
  console.log("Generated token:", token);
  response.send(token);  
});
