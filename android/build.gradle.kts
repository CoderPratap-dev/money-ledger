allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.set(rootProject.rootDir.resolve("../build"))

subprojects {
    project.layout.buildDirectory.set(rootProject.layout.buildDirectory.get().asFile.resolve(project.name))
    
    afterEvaluate {
        extensions.findByType(com.android.build.gradle.BaseExtension::class.java)?.apply {
            // 1. Fix the missing namespace issue
            if (namespace == null) {
                namespace = project.group.toString()
            }
            
            // 2. FORCE ISAR AND OTHER PLUGINS TO COMPILE AGAINST A NEWER SDK VERSION
            compileSdkVersion(35) 
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}