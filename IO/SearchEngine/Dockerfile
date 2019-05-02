FROM swift:5.0.1

WORKDIR /app

COPY . .

RUN swift build -c release -Xswiftc -O -Xswiftc -whole-module-optimization

CMD [".build/x86_64-unknown-linux/release/SearchEngine"]