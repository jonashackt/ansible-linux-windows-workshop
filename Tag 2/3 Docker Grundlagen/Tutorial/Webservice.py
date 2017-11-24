#!/usr/bin/env python
import web

urls = (
    '/hello', 'hello'
)

app = web.application(urls, globals())

class hello:
    def GET(self):
        return "Hello world."

if __name__ == "__main__":
    app.run()
