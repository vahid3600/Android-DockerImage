# gitlab-ci-android

https://hub.docker.com/r/inovex/gitlab-ci-android/

```
image: behdad222/android-sdk:v1


before_script:

  - chmod +x ./gradlew
  
  - export VERSION_NAME=`egrep '^[[:blank:]]+sdkVersion[[:blank:]]'  ./build.gradle | awk '{print $3}' | sed s/\'//g`
  
  - touch ./info.txt
  - echo "Build date          $(date)"                >> ./info.txt
  - echo "SDK version         ${VERSION_NAME}"        >> ./info.txt
  - echo "Git branch          ${CI_COMMIT_REF_NAME}"  >> ./info.txt
  - echo "Git commit          ${CI_COMMIT_SHA}"       >> ./info.txt
  - echo "Gitlab pipeline     ${CI_PIPELINE_ID}"      >> ./info.txt
  

stages:
  - code_quality
  - build
  - release
  - publish
  
  
cache:
  key: ${CI_PROJECT_ID}
  paths:
  - .gradle/


static_analysis:
  stage: code_quality
  
  script:
    - ./gradlew checkstyle
    
  allow_failure: true
    
  artifacts:
    name: "reports_${CI_PROJECT_NAME}_${CI_BUILD_REF_NAME}"
    
    paths:
      - ./build/reports/checkstyle/checkstyle.html
      - ./info.txt
      
    when: always
      

build-sdk-android:
  stage: build
  
  script:
    - ./gradlew assembleAndroid
    - mv ./sdk/build/outputs/aar/sdk-android-debug.aar ./sdk-android-debug-v$VERSION_NAME.aar
    
  artifacts:
    paths:
    - ./*.aar
    - ./info.txt


build-app-android:
  stage: build
  
  script:
    - ./gradlew assembleDebug
    - mv ./app/build/outputs/apk/debug/app-debug.apk ./app-android-debug-v$VERSION_NAME.apk
    
  artifacts:
    paths:
    - ./*.apk
    - ./info.txt


release-sdk-android:
  stage: release
  
  only:
    - master
    - release
    
  script:
    - ./gradlew assembleAndroidRelease
    - mv ./sdk/build/outputs/aar/sdk-android-release.aar ./sdk-android-release-v$VERSION_NAME.aar
    - mv ./sdk/build/outputs/logs/manifest-merger-android-release-report.txt .
    - mv ./sdk/build/outputs/mapping/android/release/* .
    
  artifacts:
    paths:
    - ./*.aar
    - ./*.txt
  
  when: manual

```
