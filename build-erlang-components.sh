#!/bin/sh -ex

CWD=`pwd`

ERLANG_VERSION="R14B04"

ERLANG_DISTRIBUTION_URL="http://www.erlang.org/download/otp_src_${ERLANG_VERSION}.tar.gz"

ERLANG_CONFIGURE_OPTS="--enable-smp-support --enable-dynamic-ssl-lib --enable-kernel-poll --enable-darwin-64bit --enable-hipe --without-javac"

ERLANG_HOME="$CWD/lib/erlang"

ESCRIPT="$ERLANG_HOME/bin/escript"

ERLC="$ERLANG_HOME/bin/erlc"

KARAJAN_URL="https://github.com/rodaebel/Karajan.git"

# Fetch the Erlang distribution
fetch_erlang()
{
  curl -O $ERLANG_DISTRIBUTION_URL
}

# Build Erlang
build_erlang()
{
  rm -rf $ERLANG_HOME
  mkdir -p $ERLANG_HOME
  rm -rf otp_src_${ERLANG_VERSION}
  tar xvzf otp_src_${ERLANG_VERSION}.tar.gz
  cd otp_src_${ERLANG_VERSION}
  if [ "`uname -r | sed -e 's,\(\.[0-9].*$\),,'`" -eq "11" ]; then
    export CFLAGS=-O0
  fi
  ./configure $ERLANG_CONFIGURE_OPTS --prefix=$ERLANG_HOME
  make
  make install
  cd -
}

# Sanitize the Erlang distribution
sanitize_erlang()
{
  cd $ERLANG_HOME
  perl -pi -e "s@ROOTDIR=${ERLANG_HOME}/lib/erlang@CWD=\`pwd\`\ncd \`dirname \\\$0\`\nROOTDIR=\`dirname \"\\\$PWD\" | sed -e 's, ,\\\\\\\\\\\\\\\\ ,g'\`/lib/erlang\ncd \\\$CWD@" bin/erl
  cd -
}

# Fetch the Karajan Erlang component
fetch_karajan()
{
  git clone $KARAJAN_URL
}

# Build the Karajan Erlang component
build_karajan()
{
  cd Karajan
  $ESCRIPT rebar get-deps
  $ESCRIPT rebar compile

  cd $CWD
}

# The main function
main()
{
  if [ ! -e "otp_src_${ERLANG_VERSION}.tar.gz" ] && [ ! -d "otp_src_${ERLANG_VERSION}" ]; then
    fetch_erlang
  fi

  if [ ! -e ".erlang-built" ]; then
    build_erlang
    touch $CWD/.erlang-built
  fi

  sanitize_erlang

  if [ ! -d "Karajan" ]; then
    fetch_karajan
  fi

  if [ ! -e ".karajan-built" ]; then
    build_karajan
    touch $CWD/.karajan-built
  fi
}

# Call the main function
main

exit 0
