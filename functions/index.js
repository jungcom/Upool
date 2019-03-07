const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
const firebase_tools = require('firebase-tools');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
/**
 * Initiate a recursive delete of documents at a given path.
 *
 * The calling user must be authenticated and have the custom "admin" attribute
 * set to true on the auth token.
 *
 * This delete is NOT an atomic operation and it's possible
 * that it may fail after only deleting some documents.
 *
 * @param {string} data.path the document or collection path to delete.
 */
exports.recursiveDelete = functions
  .runWith({
    timeoutSeconds: 540,
    memory: '2GB'
  })
  .https.onCall((data, context) => {
    // Only allow admin users to execute this function.
    if (!(context.auth && context.auth.token)) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Must be an administrative user to initiate delete.'
      );
    }

    const path = data.path;
    console.log(
      `User ${context.auth.uid} has requested to delete path ${path}`
    );

    // Run a recursive delete on the given document or collection path.
    // The 'token' must be set in the functions config, and can be generated
    // at the command line by running 'firebase login:ci'.
    return firebase_tools.firestore
      .delete(path, {
        project: process.env.GCLOUD_PROJECT,
        recursive: true,
        yes: true,
        token: functions.config().fb.token
      })
      .then(() => {
        return {
          path: path
        };
      });
  });

exports.observeChatMessagesfunctions = functions.firestore
    .document('messages/{messageId}')
    .onCreate((snap, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}
    const message = snap.data();

    // access a particular field as you would any JS property
    console.log('Message from : ' + message.fromId + 'that says : ' + message.text);

    return admin.firestore().collection('users').doc(message.toId).get().then(function(doc) {
        if (doc.exists) {
            var toUser = doc.data()
            
            return admin.firestore().collection('users').doc(message.fromId).get().then(function(doc) {
                if (doc.exists) {
                    var fromUser = doc.data()
                    var payload = {
                        notification: {
                            title: 'New Message from ' + fromUser.firstName,
                            body: message.text,
                            sound : 'chime.aiff',
                            badge : '1'
                        },
                        data : {
                            toId : message.fromId
                        }
                    };

                    // Send Message to the device
                    admin.messaging().sendToDevice(toUser.fcmToken, payload)
                        .then((response) => {
                            // Response is a message ID string.
                            console.log('Successfully sent message:', response);
                            return response;
                        }).catch((error) => {
                            console.log('Error sending message:', error);
                        });
                } else {
                    // doc.data() will be undefined in this case
                    console.log("No such document!");
                }
                return null;
            })
        }
        return null;
    }).catch(function(error) {
        console.log("Error getting document:", error);
    });
    // perform desired operations ...
});

exports.observeRideRequestCreatedFunction = functions.firestore
    .document('rideRequests/{rideRequestId}')
    .onCreate((snap, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}
    const rideRequest = snap.data();

    // access a particular field as you would any JS property
    console.log('New Ride Request from : ' + rideRequest.fromIdFirstName + 'to ridePost id : ' + rideRequest.ridePostId);

    return admin.firestore().collection('users').doc(rideRequest.toDriverId).get().then(function(doc) {
        if (doc.exists) {
            var toDriverUser = doc.data()
            var payload = {
                notification: {
                    title: "New Request",
                    body: rideRequest.fromIdFirstName + " has requested to join your ride",
                    sound : 'chime.aiff',
                    badge : '1'
                },
                data : {
                    ridePostId : rideRequest.ridePostId
                }
            };

            // Send Message to the device
            admin.messaging().sendToDevice(toDriverUser.fcmToken, payload)
                .then((response) => {
                    // Response is a message ID string.
                    console.log('Successfully sent message:', response);
                    return response;
                }).catch((error) => {
                    console.log('Error sending message:', error);
                });
        } else {
            // doc.data() will be undefined in this case
            console.log("No such document!");
        }
        return null;
    }).catch(function(error) {
        console.log("Error getting document:", error);
    });
    // perform desired operations ...
});

exports.rideRequestAcceptedOrDeclined = functions
  .https.onCall((data, context) => {
    // Only allow admin users to execute this function.
    if (!(context.auth && context.auth.token)) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Must be an administrative user to initiate delete.'
      );
    }

    const toUserId = data.toUserId;
    const accepted = data.accepted;
    console.log(
      `User ${context.auth.uid} has accepted or declined a request ${toUserId}`
    );

    return admin.firestore().collection('users').doc(toUserId).get().then(function(doc) {
      if (doc.exists) {
          var toUser = doc.data()
          if (accepted){
            var payload = {
              notification: {
                  title: "Ride Accepted",
                  body: "Your ride request has been accepted",
              },
              data : {
                  toUserId : toUserId
              }
            };
          } else {
            payload = {
              notification: {
                  title: "Ride Declined",
                  body: "Your ride request has been declined",
              },
              data : {
                  toUserId : toUserId
              }
            };
          }

          // Send Message to the device
          admin.messaging().sendToDevice(toUser.fcmToken, payload)
              .then((response) => {
                  // Response is a message ID string.
                  console.log('Successfully sent message:', response);
                  return response;
              }).catch((error) => {
                  console.log('Error sending message:', error);
              });
      } else {
          // doc.data() will be undefined in this case
          console.log("No such document!");
      }
      return null;
  }).catch(function(error) {
      console.log("Error getting document:", error);
  });
});