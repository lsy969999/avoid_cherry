package com.example.avoid_cherry

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import com.example.avoid_cherry.ui.theme.MyApplicationTheme

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = colorResource(id = R.color.white)
                ) {
                    SurfaceCard()
                }
            }
        }
    }
}

var surfaceView: BevySurfaceView? = null

@Composable
fun SurfaceCard() {
    var selected by remember { mutableStateOf("Breakout") }
    val toggleValues = listOf("Breakout", "XXX",)
    val screenWidth = LocalConfiguration.current.screenWidthDp
    Column(modifier = Modifier.fillMaxSize()) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center,
            modifier = Modifier
                .height(44.dp)
                .padding(horizontal = 0.dp, vertical = 7.dp)
                .fillMaxWidth()
        ) {
            Text(text = "Bevy in Android App", fontSize = 20.sp, fontWeight = FontWeight.Bold)
        }
//        Row(
//            verticalAlignment = Alignment.CenterVertically,
//            horizontalArrangement = Arrangement.Center,
//            modifier = Modifier
//                .height(54.dp)
//                .padding(horizontal = 0.dp, vertical = 9.dp)
//                .fillMaxWidth()
//        ) {
//            ToggleButton(
//                currentSelection = selected,
//                toggleStates = toggleValues,
//                onToggleChange = { title ->
//                    selected = title
//                    toggleValues.forEachIndexed { idx, v ->
//                        if (v == title) {
//                            surfaceView?.changeExample(idx)
//                        }
//                    }
//                },
//            )
//
//        }
        Spacer(modifier = Modifier.height(8.dp))
        AndroidView(
            factory = { ctx ->
                val sv = BevySurfaceView(context = ctx)
                surfaceView = sv
                sv
            },
            modifier = Modifier
                .fillMaxWidth()
                .height((screenWidth.toFloat() * 1.6).dp),
        )
    }
}
