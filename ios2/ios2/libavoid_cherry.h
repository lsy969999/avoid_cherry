//
//  libavoid_cherry.h
//  avoid_cherry
//
//  Created by SY L on 1/13/24.
//

#ifndef libavoid_cherry_h
#define libavoid_cherry_h

#include <stdint.h>

struct bevy_app;

struct bevy_app *create_bevy_app(void *view, int maximum_frames, float scale_factor);

void enter_frame(struct bevy_app *app);
void release_bevy_app(struct bevy_app *app);

void touch_started(struct bevy_app *app, float x, float y);
void touch_moved(struct bevy_app *app, float x, float y);
void touch_ended(struct bevy_app *app, float x, float y);
void touch_cancelled(struct bevy_app *app, float x, float y);

void gyroscope_motion(struct bevy_app *app, float x, float y, float z);
void accelerometer_motion(struct bevy_app *app, float x, float y, float z);
void device_motion(struct bevy_app *app, float x, float y, float z);

#endif /* libavoid_cherry_h */
