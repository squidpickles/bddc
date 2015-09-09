# bddc - BIND dynamic DNS client

This application is for folks with a dynamic IP and access to a server running BIND v8 or above.

It will find your primary IP address and send updates to your name server whenever it changes. You can sign those changes with a TSIG key, allowing for secure access control.

The program is essentially a wrapper for the `nsupdate(8)` command; you probably should be familiar with its quirks before you try messing with this application.

## Requirements:
Dunno. I think it'll only work in OS 10.2, but give it a try on any OS X or above system.

## Installation:
(kinda -- this is just a rough guide)
  1. Compile both targets in Xcode
  2. create an empty file (using touch or something): `~/Library/Application Support/bddc/lastIPaddr.xml`
  3. Move `bddc.prefpane` (in the build directory) to `~/Library/PreferencePanes`
  4. Move `bddc.app` wherever you like.
  5. Setup `bddc.app` to run on login
  6. Log out/in, or restart

Settings are in the System Preferences. They should be self-explanatory.

## Disclaimer:
This code has no comments, is probably quite buggy, etc. It's my first Obj-C project, and I wrote it for myself, not for deployment. Usage is totally at your own risk.

I cannot and will not support this application for end users. If you're developing using some of this code, I can answer questions for general education's sake.

Enjoy!
