// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract VerifyingSigs {
    /* 
How to Sign and Verify...

# Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer
*/

    /* 1. Unlock MetaMask account in Browser Console
    ethereum.enable()
    */

    /* 2. Get message hash to sign
    getMessageHash(
        0xFF985509Aa523FE9cd3d0A6891fCB9f2A4134feE,
        123
        "alien greys are here",
        83
    )

    hash = "0x2701fe3c11ae8f6048936adf4012b748ac5dd3345a1fa7d47428ccee0f00b403"
    */
    function getMessageHash(
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /* 3. Sign message hash
    # using browser
    account = "copy paste account of signer here"
    ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)

    # using web3
    web3.personal.sign(hash, web3.eth.defaultAccount, console.log)

    Signature will be different for different accounts
    0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
    */

    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        /*
        Signature is produced by signing a keccak256 hash with the following format:
        "\x19Ethereum Signed Message\n" + len(msg) + msg
        */
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    /* 4. Verify signature
    signer = 0xB273216C05A8c0D4F0a4Dd0d7Bae1D2EfFE636dd
    to = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
    amount = 123
    message = "coffee and donuts"
    nonce = 1
    signature =
        0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
    */

    //See all inputs needed to verify-  _signer, _to, _amount, _message, _nonce, signature
    function verify(
        address _signer,
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        //we need to hash the message (input). See "getMessageHash(_message)" function below.
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        //now we need to sign the message off chain.  We pass in the messageHash from step 1 above.
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        //See below for getEthSignedMessageHash(messageHash) function
        //now we will take ethSignedMessagedHash above, verify it with the bytes memory _sig. This will      recover the signer so we'll check that
        //the signer returned was equal to the signer from the input (bytes memory _sig). This compares == and returns the bool.
        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    //Now that we have the ethSignedMessage we can write the function that takes this along with the signature (_sig) and recovers the signer.
    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        //first thing we need to do is split the signature into 3 parts
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature); //see _splitSignature function below
        //now we can pass in v,r, & s along with the _ethSignedMessageHash to ecrecover
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }
}
