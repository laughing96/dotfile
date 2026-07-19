// 是否正在 warmup
let warming = false;

// 上一次 warmup 时间
let lastWarmup = 0;

// 5 分钟内只 warmup 一次
const WARMUP_INTERVAL = 5 * 60 * 1000;

chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {

    if (changeInfo.status !== "loading")
        return;

    if (!tab.url)
        return;

    // 不是 last.fm
    if (!tab.url.startsWith("https://www.last.fm/"))
        return;

    // home 自己不处理
    if (tab.url.startsWith("https://www.last.fm/home"))
        return;

    // 已经在 warmup
    if (warming)
        return;

    // 最近已经 warmup
    if (Date.now() - lastWarmup < WARMUP_INTERVAL)
        return;

    warming = true;

    console.log("Start Last.fm warmup");

    chrome.tabs.create({
        url: "https://www.last.fm/home",
        active: false
    }, (warmTab) => {

        const listener = (id, info) => {

            if (id !== warmTab.id)
                return;

            if (info.status !== "complete")
                return;

            chrome.tabs.onUpdated.removeListener(listener);

            lastWarmup = Date.now();
            warming = false;

            console.log("Warmup finished");

            chrome.tabs.remove(warmTab.id);

        };

        chrome.tabs.onUpdated.addListener(listener);

    });

});
