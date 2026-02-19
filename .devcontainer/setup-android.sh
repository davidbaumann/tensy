: #!/bin/bash
set -e

echo "🚀 Setting up Android SDK, NDK and build tools..."

# Create Android SDK directory
mkdir -p /home/vscode/android-sdk

# Download and install Android SDK Command Line Tools
cd /tmp
wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip -q commandlinetools-linux-*_latest.zip
mkdir -p /home/vscode/android-sdk/cmdline-tools
mv cmdline-tools /home/vscode/android-sdk/cmdline-tools/latest
rm commandlinetools-linux-*_latest.zip

# Set up environment variables
export ANDROID_SDK_ROOT=/home/vscode/android-sdk
export ANDROID_HOME=/home/vscode/android-sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# Accept licenses
mkdir -p /home/vscode/.android
echo -e "\n\nrepositories.cfg=count=0\n" > /home/vscode/.android/repositories.cfg

# Install Android components (silently accept licenses)
echo "Installing Android SDK Platform 33..."
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platforms;android-33" > /dev/null 2>&1
echo "Installing Android NDK 26.1.10909125..."
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "ndk;26.1.10909125" > /dev/null 2>&1
echo "Installing Build Tools 34.0.0..."
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "build-tools;34.0.0" > /dev/null 2>&1
echo "Installing Android SDK Tools..."
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "cmdline-tools;latest" > /dev/null 2>&1

# Fix permissions
chown -R vscode:vscode /home/vscode/android-sdk
chown -R vscode:vscode /home/vscode/.android
echo "✅ Android SDK and NDK setup complete!"
echo "📍 ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "📍 ANDROID_NDK_ROOT: $ANDROID_SDK_ROOT/ndk/26.1.10909125"
echo ""
echo "You can now build the Android app with:"
echo "  cd android"
echo "  ./gradlew build"