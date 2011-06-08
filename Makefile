all: .erlang-built .karajan-built
	@xcodebuild

.erlang-built .karajan-built:
	./build-erlang-components.sh

clean:
	@xcodebuild clean
	rm -rf build

distclean:
	rm -f .erlang-built .karajan-built
	rm -rf build lib otp_src_* Karajan
