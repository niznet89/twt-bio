const { toChecksumAddress } = require('ethereum-checksum-address')

// the button to connect to an ethereum wallet
const buttonEthConnect = document.getElementById('sign-up');
// the read-only eth address field, we process that automatically
const formInputEthAddress = document.getElementById('user_eth_address');
const formInputEthCheckSum = document.getElementById('user_eth_checksum');
console.log(formInputEthAddress);
// get the user form for submission later
const formNewUser = document.getElementById('new_user');
// only proceed with ethereum context available

if (typeof window.ethereum !== 'undefined') {
  buttonEthConnect.addEventListener('click', async () => {
    // request accounts from ethereum provider
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    console.log(accounts)
    // populate and submit form
    formInputEthAddress.value = accounts[0];
    formInputEthCheckSum.value = toChecksumAddress(accounts[0]);
    formNewUser.submit();
  });
}
