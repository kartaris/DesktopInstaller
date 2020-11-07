
QT_DIR= $$[QT_HOST_BINS]

win32:QMAKE_BIN= $$QT_DIR/qmake.exe
win32:LUPDATE = $$QT_DIR/lupdate.exe
win32:LRELEASE = $$QT_DIR/lrelease.exe
win32:DEPLOYER=$$(cqtdeployer)


contains(QMAKE_HOST.os, Linux):{
    QMAKE_BIN= $$QT_DIR/qmake
    LUPDATE = $$QT_DIR/lupdate
    LRELEASE = $$QT_DIR/lrelease
    DEPLOYER = cqtdeployer
}

android {
    DEPLOYER = $$QT_DIR/androiddeployqt
}

message( PWD :$$PWD)

message( Configuration variables :)
message(QT_DIR = $$QT_DIR)
message(QMAKE_BIN = $$QMAKE_BIN)
message(LUPDATE = $$LUPDATE)
message(LRELEASE = $$LRELEASE)
message(DEPLOYER = $$DEPLOYER)

BINARY_LIST
REPO_LIST

exists( $$QT_DIR/binarycreator ) {
        BINARY_LIST += $$QT_DIR/binarycreator
}
exists( $$QT_DIR/repogen ) {
        REPO_LIST += $$QT_DIR/repogen
}

isEmpty (BINARY_LIST) {
      error( "QtInstallerFramework not found!" )
}

win32:EXEC=$$first(BINARY_LIST).exe
win32:REPOGEN=$$first(REPO_LIST).exe

contains(QMAKE_HOST.os, Linux):{
    unix:EXEC=$$first(BINARY_LIST)
    win32:EXEC=wine $$first(BINARY_LIST).exe

    REPOGEN=$$first(REPO_LIST)
}

message( selected $$EXEC and $$REPOGEN)


