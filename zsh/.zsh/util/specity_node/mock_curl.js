import { spawn } from "child_process";
import express from "express";
// const path = require('path')
import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function runCurl({ url, cookie, headers = [], output }) {
    return new Promise((resolve, reject) => {
        const args = [];

        if (cookie) {
            args.push("-b", cookie);
        }

        headers.forEach((h) => {
            args.push("-H", h);
        });

        if (output) {
            args.push("-o", output);
        }

        args.push("-s");
        args.push(url);

        let data = "";
        const curl = spawn("curl", args);

        curl.stdout.on("data", (chunk) => {
            data += chunk.toString();
        });

        curl.stderr.on("data", (chunk) => {
            console.error(chunk.toString());
        });
        // console.log(data);

        curl.on("close", (code) => {
            // console.log('done:', code);
            resolve({
                ok: true,
                status: 200,
                text: async () => data,
                json: async () => {
                    try {
                        return JSON.parse(data);
                    } catch (e) {
                        throw new Error("JSON parse error");
                    }
                },
            });
        });

        curl.on("error", reject);
    });
}

const app = express();

app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    next();
});

function getCookie() {
    return new Promise((resolve, reject) => {

        const python_root = path.join(__dirname, 'spicety_reddit');
        const python_file = path.join(python_root,'main.py') 
        const python_exe = path.join(python_root,'.venv','bin','python')
        const py = spawn(python_exe, [python_file]);
        let stdout = "";
        let stderr = "";
        py.stdout.on("data", (data) => {
            // 这里是流, 可能返回多端 需要拼接
            stdout += data.toString();
        });
        py.stderr.on("data", (data) => {
            stderr += data.toString();
        });
        py.on("close", (code) => {
            if (code != 0) {
                // console.error('error', stderr)
                return reject(stderr);
            }
            try {
                const result = JSON.parse(stdout.trim());
                resolve(result.cookie);
                // console.log('result', result)
            } catch (e) {
                // console.error('error', stdout)
                reject("error" + e);
            }
        });
    });
}
const cookie = await getCookie();
// console.log(cookie);

const headers = [
    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "accept-language: en,zh-CN;q=0.9,zh;q=0.8",
    "cache-control: max-age=0",
    "priority: u=0, i",
    'sec-ch-ua: "Chromium";v="146", "Not-A.Brand";v="24", "Google Chrome";v="146"',
    "sec-ch-ua-mobile: ?0",
    'sec-ch-ua-platform: "macOS"',
    "sec-fetch-dest: document",
    "sec-fetch-mode: navigate",
    "sec-fetch-site: none",
    "sec-fetch-user: ?1",
    "upgrade-insecure-requests: 1",
    "user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36",
];

app.get("/reddit/:sub/:config", async (req, res) => {
    try {
        const sub = req.params.sub;
        const config = req.params.config;
        const url = `https://www.reddit.com/r/${sub}/${config}.json?limit=100&count=10&raw_json=1`;
        // console.log(`url is ${url}`)
        if (req.query.after){
            url += `&after=${req.query.after}`
        } 
        if (req.query.t){
            url += `&t=${req.query.t}`
        }
        const response = await runCurl({
            url: url,
            cookie,
            headers,
        });

        const data = await response.json();
        res.json(data);
    } catch (err) {
        res.status(500).json({ error: err.toString() });
    }
});

app.listen(3000, () => {
    // console.log("Spotify reddit Proxy running on http://localhost:3000");
});
