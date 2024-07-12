import { createServer } from "node:http"
import { readFileSync } from "node:fs"
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

const requestHandler = async (request, response) => {
    const { url, method } = request

    if (URLS.index === url && 'GET' === method) {
        writePageIndex(response)
    }

    if (URLS.index === url && 'POST' === method) {
        const form = formidable({
            uploadDir: saveToPath,
            keepExtensions: true,
        })
        const [_, files] = await form.parse(request)
        writePageIndex(response, `<p>You have previously saved ${files.receipts.length} photos!</p>`)
    }

    if (URLS.close === url) {
        process.exit()
    }
}

const server = createServer()
server.on('request', requestHandler)
server.listen(port)
