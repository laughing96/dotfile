1. ./install.sh
2. 修改原来~/.config/spicetify/CustomApps/reddit/index.js的reddit 的index.js 中的 getSubreddit,
    replace url to 
    ```JavaScript
    url = `http:127.0.0.1:3000/reddit/${CONFIG.lastService}/${sortConfig.by}`
    ```
3. then node

自己学习js的一个小尝试, 解决自己不能访问reddit的问题.
done

node 里面找路径
```JavaScript
import path from "path"
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename);

```

Promise 微服务

setTime 宏服务

不区分函数 
事件轮询

返回的是流, 
在 spawn 调用的时候,返回流 chunk 要先累加, finally operation
py = spawn(python_exe, python_file)
py.stdout.on on就是事件监听
> 前端的回调 监听 事件轮询 都是一个概念

```JavaScript
new Promise((resolve, reject)) 
    resolve 是成功的函数
    reject 失败的函数
```

.on('xxx') 是 事件名 event name, 由具体对象定义

不是 JavaScript 而是 Node 的EventEmitter
stream 定义了 data end error
子进程定义了 close exit data child.stderr.on('data', fn)
general use 'error'
写错了不报错,永远不触发
具体内容需要查对象

typescript 是静态的一种. 像rust, 最后还是编程JavaScript, 大家都不想太累
