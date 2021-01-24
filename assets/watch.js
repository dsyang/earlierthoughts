// Script to work around --watch-options-stdin not working.
//  https://github.com/phoenixframework/phoenix/pull/4054
const process = require("process")
const child_process = require("child_process")

const stdin = process.openStdin()

const child = child_process.spawn(
    "node_modules/webpack/bin/webpack.js",
    ["--mode", "development", "--watch"],
    { detached: true },
)

const endAll = () => {
    process.kill(child.pid)
    process.exit(0)
}

child.stderr.on("data", (data) => console.error(data.toString("utf8")))
child.stdout.on("data", (data) => console.log(data.toString("utf8")))

stdin.on("end", endAll)

process.on("SIGINT", endAll)