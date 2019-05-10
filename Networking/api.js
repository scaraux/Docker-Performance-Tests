const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
    setTimeout(() => {
        res.send('Hello World!')
    }, 300)
})

app.listen(port, () => {
    console.log(`API listening on port ${port}!`)
})
