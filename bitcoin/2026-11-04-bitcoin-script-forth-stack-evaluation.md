# TIL 2026-11-04: Bitcoin Script Stack Machine & CScriptNum Encoding

## Key Insights
1. **Forth-like Stack Machine:** Bitcoin Script uses a linear, two-stack architecture (`STACK` and `ALTSTACK`) without loops (`JMP`, `GOTO`, and recursive constructs are intentionally omitted) to eliminate Denial of Service (DoS) attacks and ensure every transaction evaluation terminates in finite linear time $O(N)$.
2. **CScriptNum Number Encoding:** Integers in Bitcoin Script are stored as little-endian sign-magnitude bytes. The most significant bit of the highest byte is the sign bit (`0x80` for negative). Zero is represented by an empty byte array `b''`.
3. **P2PKH Validation Contract:**
   - Spender pushes `<signature>` and `<pubkey>`.
   - UTXO script executes: `OP_DUP` -> `OP_HASH160` -> `PUSH <pubKeyHash>` -> `OP_EQUALVERIFY` -> `OP_CHECKSIG`.
   - If public key hash fails to match, `OP_EQUALVERIFY` immediately halts execution and fails the transaction before `OP_CHECKSIG` is even reached.
