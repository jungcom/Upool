# *UPool*

<img src='https://i.imgur.com/KPEDnOK.jpg' title='UPool' width='' />

**UPool** is a carpool app for Umass Amherst using a Firebase backend.
challenges
The following functionalities are implemented:

- [O] User can sign up and sign in to the login screen (Firebase Authentication)
- [O] User can sign up with an email and it requires email verification (Also works for password resets)
- [O] Persist logged in user
- [O] User can post a ride post With the help of Google Places API
- [O] More user friendly UI/UX
- [O] User has a status tab that shows the list of rides they are riding and offering
- [O] Users can send requests to others and accept rides
- [O] User can compose and send chat messages to other peers AND also send push notifications to the receiving users with Firebase Cloud Functions

The following functionalities should be implemented:

- [ ] User has a profile page which can edit their information, indluding their profile picture
- [ ] Users can decline ride requests
- [ ] Users can delete their posted rides using recursive delete with Firebase Cloud Functions
- [ ] Users can receive and give ratings to others
- [ ] Chat shows the time log in a more efficient manner, with the date of the chat as headers
- [ ] Users can receive push notifications when they are accepted on a ride


## Video Walkthrough/ScreenShots

Here are screenshots of the app:

<img src='https://i.imgur.com/4ewUkOU.png' title='ScreenShots' width='200' />
<img src='https://i.imgur.com/UnAtZEj.png' title='ScreenShots' width='200' />
GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any difficulties encountered while building the app.

Handling the server database is somewhat tricky in terms of retrieving, updating, adding, and deleting data.

Handling push notifications with Firebase Cloud functions is challenging, because the cloud functions have to be written in node.js

## License

    Copyright [2019] [Anthony Lee]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
