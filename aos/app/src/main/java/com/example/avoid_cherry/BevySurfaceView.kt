package com.example.avoid_cherry

import android.content.Context
import android.graphics.Canvas
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.AttributeSet
import android.util.Log
import android.view.SurfaceHolder
import android.view.SurfaceView

class BevySurfaceView : SurfaceView, SurfaceHolder.Callback2 {
    private var rustBrige = RustBridge()
    private var bevy_app: Long = Long.MAX_VALUE
    private var idx: Int = 0
    private var sensorManager: SensorManager? = null
    private var mSensor: Sensor? = null
    private var sensorValues: FloatArray = FloatArray(3)

    constructor(context: Context) : super(context) {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        mSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_GRAVITY)
    }
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
    }
    constructor(context: Context, attrs: AttributeSet, defStyle: Int) : super(
        context,
        attrs,
        defStyle
    ) {
    }

    init {
        // 현재 클래스를 SurfaceHolder의 콜백 인터페이스 프록시로 설정
        holder.addCallback(this)
        rustBrige.init_ndk_context(this.context)
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
    }

    // 그리기 화면이 생성된 후 Bevy App을 생성/재작성합니다.
    override fun surfaceCreated(holder: SurfaceHolder) {
        Log.d("TAG", "surfaceCreated: !!!")
        holder.let { h ->
            Log.d("TAG", "surfaceCreated: !!!  holder.let")


            // Get the screen's density scale
            val scaleFactor: Float = resources.displayMetrics.density
            bevy_app = rustBrige.create_bevy_app(this.context.assets, h.surface, scaleFactor)

            // SurfaceView는 기본적으로 자동으로 그리기를 시작하지 않습니다. setWillNotDraw(false)는 그리기를 시작할 준비가 되었음을 앱에 알리는 데 사용됩니다.
            setWillNotDraw(false)

            var sensorEventListener = object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent?) {
                    if (event != null) {
                        sensorValues = event.values
                    }
                }

                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
                }
            }
            mSensor?.also { sensor ->
                sensorManager?.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_GAME)
            }
        }
    }

    // 그리기 화면이 파괴된 후 Bevy App도 파괴됩니다.
    override fun surfaceDestroyed(holder: SurfaceHolder) {
        Log.d("TAG", "surfaceDestroyed: !!!")
        if (bevy_app != Long.MAX_VALUE) {
            Log.d("TAG", "release_bevy_app: !!!")
            rustBrige.release_bevy_app(bevy_app)
            bevy_app = Long.MAX_VALUE
        }
    }

    override fun surfaceRedrawNeeded(holder: SurfaceHolder) {
    }

    // API Level 26+
//    override fun surfaceRedrawNeededAsync(holder: SurfaceHolder, drawingFinished: Runnable) {
//        super.surfaceRedrawNeededAsync(holder, drawingFinished)
//    }

    override fun draw(canvas: Canvas) {
        super.draw(canvas)
        if (bevy_app == Long.MAX_VALUE) {
            return
        }
        rustBrige.device_motion(bevy_app, sensorValues[0], sensorValues[1], sensorValues[2])
        rustBrige.enter_frame(bevy_app)
        // invalidate() 函数通知通知 App，在下一个 UI 刷新周期重新调用 draw() 函数
        invalidate()
    }

    fun changeExample(index: Int) {
        if (bevy_app != Long.MAX_VALUE && this.idx != index) {
            this.idx = index
        }
    }
}