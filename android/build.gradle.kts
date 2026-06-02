allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    plugins.withId("com.android.library") {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val namespace = getNamespace.invoke(android)
                if (namespace == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    var manifestPackage: String? = null
                    val manifestFile = project.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        val manifestContent = manifestFile.readText()
                        val matchResult = Regex("package=\"([^\"]+)\"").find(manifestContent)
                            ?: Regex("package='([^']+)'").find(manifestContent)
                        manifestPackage = matchResult?.groupValues?.get(1)
                    }
                    val defaultNamespace = manifestPackage ?: ("com.example." + project.name.replace("-", "_").replace(":", "_"))
                    setNamespace.invoke(android, defaultNamespace)
                }
            } catch (e: Exception) {
                // Ignore errors if the extension does not support namespace
            }
        }
    }
    plugins.withId("com.android.application") {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val namespace = getNamespace.invoke(android)
                if (namespace == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    var manifestPackage: String? = null
                    val manifestFile = project.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        val manifestContent = manifestFile.readText()
                        val matchResult = Regex("package=\"([^\"]+)\"").find(manifestContent)
                            ?: Regex("package='([^']+)'").find(manifestContent)
                        manifestPackage = matchResult?.groupValues?.get(1)
                    }
                    val defaultNamespace = manifestPackage ?: ("com.example." + project.name.replace("-", "_").replace(":", "_"))
                    setNamespace.invoke(android, defaultNamespace)
                }
            } catch (e: Exception) {
                // Ignore errors if the extension does not support namespace
            }
        }
    }
}




tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
