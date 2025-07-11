# HaskellPortListener

This is a small HTTP service written in **Haskell** using **Scotty**.  
It demonstrates:
- A simple POST endpoint to accept and remember text input.
- A GET endpoint to query how many times a string has been seen.
- Safe concurrent state using `MVar`.

---

## How it works

- **POST /input**  
  - Submit a plain string in the request body.
  - The server remembers it.
- **GET /query?key=YOUR_STRING**  
  - Check how many times you’ve submitted this exact string.
  - Returns the count as plain text.

---

## Project files

- `app/Main.hs` — the main web server.
- `my-project.cabal` — Cabal project config.

---

## Requirements

- [GHC](https://www.haskell.org/ghc/) — Haskell compiler.
- [Cabal](https://www.haskell.org/cabal/) — Haskell build tool.

## How to Run
 - cabal update
 - cabal build
 - cabal run
 - In another terminal, run: curl -X POST -d "hello" http://localhost:9000/input
 - Then run: curl "http://localhost:9000/query?key=hello" to see a result for how many times you posted that string value