import { createServer } from "node:http"
import { readFileSync, createWriteStream } from "node:fs"
import { join, sep } from "node:path"
import formidable from 'formidable';

const [app, main, port, saveToPath] = process.argv
const projectDirectory = saveToPath.split(sep).slice(0, -1).join(sep)

const URLS = {
    index: '/',
    close: '/close',
}

const PAGES = {
    index: join(projectDirectory, 'index.html'),
}

const CONTENT = {
    index: readFileSync(PAGES.index, { encoding: "utf-8" }),
}

function createLogger() {
    const file = createWriteStream(join(process.cwd(), "web_server.log.txt"), { encoding: "utf8", flags: "a" });
    const setDate = (now) => now.toLocaleString()
    const log = (messsage) => file.write(`[LOG] [${setDate(new Date())}] ${messsage}\n`)
    const error = (error) => file.write(`${error}\n`)
    return { end: () => file.end(), log, error };
}

function writePageIndex(response, element) {
    response.setHeader("Content-Type", "text/html")
    response.writeHead(200)

    if(element) {
        const spliter = '</form>'
        const [head, tail] = CONTENT.index.split(spliter)
        response.write(head + spliter)
        response.write(element)
        response.write(tail)
        return response.end();
    }

    response.write(CONTENT.index)
    response.end()
}

const logger = createLogger()
const server = createServer()

async function requestHandler (request, response) {
    const { url, method } = request

    if (URLS.index === url && 'GET' === method) {
        logger.log('Request to get index page')
        writePageIndex(response)
    }

    if (URLS.index === url && 'POST' === method) {
        logger.log('Request to save photos')
        const form = formidable({
            uploadDir: saveToPath,
            keepExtensions: true,
        })
        const [_, files] = await form.parse(request)
        writePageIndex(response, `<p>You have previously saved ${files.receipts.length} photos!</p>`)
    }

    if (URLS.close === url) {
        logger.log('Request to close application')
        server.close()
        setTimeout(() => server.closeAllConnections(), 3000)
        return response.end();
    }
}

server.on('request', requestHandler)
server.on("error", (error) => logger.error(error))
server.on("close", () => {
    logger.log('Application close')
    logger.end()
    process.exit()
})
server.listen(port)
logger.log('Application start')
