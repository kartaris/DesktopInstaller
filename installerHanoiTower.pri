include(InstallerBase.pri);
mkpath( $$PWD/../Distro)
win32:OUT_FILE = HanoiTowerInstaller.exe
unix:OUT_FILE = HanoiTowerInstaller.run

IGNORE_ENV=$$PWD/../Distro/,$$PWD/../deployTests,$$PWD/packages/HanoiTower/data/
BASE_DEPLOY_FLAGS = clear -qmake $$QMAKE_BIN -libDir $$PWD/../ -recursiveDepth 5 -ignoreEnv $$IGNORE_ENV -targetDir $$PWD/HanoiTower/Snake/data

ANDROID_BUILD_DIR = $$PWD/../android-build
QML_DIR = $$PWD/../hanoi_towers/
DEPLOY_TARGET = $$PWD/../hanoi_towers/build/release


deploy_dep.commands += $$DEPLOYER -bin $$DEPLOY_TARGET -qmlDir $$QML_DIR $$BASE_DEPLOY_FLAGS
install_dep.commands = make INSTALL_ROOT=$$ANDROID_BUILD_DIR install


mkpath( $$PWD/../Distro)

win32:CONFIG_FILE = $$PWD/config/configWin.xml
unix:CONFIG_FILE = $$PWD/config/configLinux.xml


deploy_dep.commands += $$DEPLOYER -bin $$DEPLOY_TARGET -qmlDir $$QML_DIR $$BASE_DEPLOY_FLAGS

install_dep.commands = make INSTALL_ROOT=$$ANDROID_BUILD_DIR install


deploy.commands = $$EXEC \
                       -c $$CONFIG_FILE \
                       -p $$PWD/packages \
                       $$PWD/../Distro/$$OUT_FILE

deploy.depends = deploy_dep

win32:ONLINE_REPO_DIR = $$ONLINE/HanoiTower/Windows
unix:ONLINE_REPO_DIR = $$ONLINE/HanoiTower/Linux

create_repo.commands = $$REPOGEN \
                        --update-new-components \
                        -p $$PWD/packages \
                        $$ONLINE_REPO_DIR

message( ONLINE_REPO_DIR $$ONLINE_REPO_DIR)
!isEmpty( ONLINE ) {

    message(online)

    release.depends = create_repo

    deploy.commands = $$EXEC \
                           --online-only \
                           -c $$CONFIG_FILE \
                           -p $$PWD/packages \
                           $$PWD/../Distro/$$OUT_FILE
}

android {

    INPUT_ANDROID = --input $$PWD/../Snake/android-libsnake.so-deployment-settings.json
    OUTPUT_ANDROID = --output $$ANDROID_BUILD_DIR
    JDK = --jdk /usr
    GRADLE = --gradle

    !isEmpty( SIGN_PATH ): !isEmpty( SIGN_STORE_PASSWORD ) {
        SIGN_VALUE = --sign '$$SIGN_PATH'

        !isEmpty( SIGN_ALIES ): {
            SIGN_VALUE += $$SIGN_ALIES
        }

        SIGN = $$SIGN_VALUE  --storepass '$$SIGN_STORE_PASSWORD' --release
        !isEmpty( SIGN_PASSWORD ): {
            SIGN += --keypass '$$SIGN_PASSWORD'
        }
    }

    deploy_dep.commands = $$DEPLOYER $$INPUT_ANDROID $$OUTPUT_ANDROID $$JDK $$GRADLE $$SIGN
    deploy_dep.depends = install_dep

    deploy.commands = cp $$ANDROID_BUILD_DIR/build/outputs/apk/* $$PWD/../Distro
}

OTHER_FILES += \
    $$PWD/config/*.xml \
    $$PWD/config/*.js \
    $$PWD/config/*.ts \
    $$PWD/config/*.css \
    $$PWD/packages/Installer/meta/* \
    $$PWD/packages/Installer/data/app.check \
    $$PWD/packages/HanoiTower/meta/* \


QMAKE_EXTRA_TARGETS += \
    installSnake \
    deploy_dep \
    install_dep \
    deploy \
    create_repo \
    release \
