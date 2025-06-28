plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.kuku_marketplace"
    compileSdk = 35 // Match required SDK

    ndkVersion = "27.0.12077973" // Match plugin requirement

    defaultConfig {
        applicationId = "com.example.kuku_marketplace"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
    release {
        // ✅ Either disable shrinkResources
        isShrinkResources = false

        // ✅ Or enable code shrinking if you want to keep it (optional)
        isMinifyEnabled = false

        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
