# VerifyingSigs

### In this project I use the Verify Signature methods to verify a signed message. The process of verifying and Signing is as follows... 
### Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

#### Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer

### After the contract is deployed via Remix Injected Web3 to the Rinkbey network I use the Chrome brower to sign the message I am sending. To verify the account that sent the message is indeed the account that signed the message we use the vefify signature function which includes recreating the hash from the original message, recovering the signer & signature hash, and finally comparing the recovered signer to the claimed signer. See photos below to verify the signed message in Browser Console is indeed the address returned in the recoverSigner function. Also notice the verify function returns a "bool true" to show the recoverd signer == claimed signer. 


<img width="507" alt="Screen Shot 2022-08-26 at 3 40 00 PM" src="https://user-images.githubusercontent.com/81759076/186984270-cb8cc525-27b0-48d6-9ce9-4d30bb0b1598.png">
<img width="490" alt="Screen Shot 2022-08-26 at 3 40 13 PM" src="https://user-images.githubusercontent.com/81759076/186984276-5c9f112a-1af3-4270-8768-5c925f7470a6.png">
<img width="506" alt="Screen Shot 2022-08-26 at 3 41 15 PM" src="https://user-images.githubusercontent.com/81759076/186984280-fb3daf11-46cd-4071-bfe8-0f5114dfee29.png">
