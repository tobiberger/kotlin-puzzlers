#!/bin/bash
# Conference Puzzler runner, requires mpeg123 and mpv for audio/video playback
# Configure it as an External Tool in IDEA with a keyboard shortcut
# Arguments: $FilePath$ $FileFQPackage$.$FileNameWithoutExtension$Kt

FILE=$1
CLASS=$2

LATEST_IDEA=$(ls -d ~/.IntelliJIdea* | tail -n 1)
[ -z "$KOTLIN_HOME" ] && KOTLIN_HOME="$LATEST_IDEA/config/plugins/Kotlin/kotlinc"
[ ! -x "$KOTLIN_HOME/bin/kotlinc" ] && chmod +x "$KOTLIN_HOME/bin/kotlin" "$KOTLIN_HOME/bin/kotlinc"

if [ -z "$2" ]; then
  echo "2 params required"
  exit 1
fi

DIR=$(dirname "$FILE")

echo "Drum roll..." >&2
screen -d -m mpg123 -k 50 drumroll.mp3

KOTLINC_ARGS="-nowarn -progressive -Xuse-experimental=kotlin.ExperimentalUnsignedTypes -Xuse-experimental=kotlin.Experimental"

if [[ $FILE == *.kts ]]; then
  java -cp "$KOTLIN_HOME/lib/*" org.jetbrains.kotlin.cli.jvm.K2JVMCompiler $KOTLINC_ARGS -script $FILE
else
  OUT="out/production/kotlin-puzzlers"
  "$KOTLIN_HOME/bin/kotlinc" $KOTLINC_ARGS -d $OUT $FILE
  "$KOTLIN_HOME/bin/kotlin" -cp $OUT $CLASS
fi

sleep 1
mpv --quiet --no-osc --ontop --no-border --autofit=50%x50% --geometry=100%:0% --loop $DIR/giphy.* 2>/dev/null >/dev/null
