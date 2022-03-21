import styles from '../styles/Mint.module.css';

export default function MintPage() {
    async function loadMoralis() {
        const serverUrl = 'https://xxxxx/server';
        const appId = 'YOUR_APP_ID';
        Moralis.start({ serverUrl, appId });
    }

    async function login() {
        let user = Moralis.User.current();
        if (!user) {
            user = await Moralis.authenticate({
                signingMessage: 'Log in using Moralis',
            })
                .then(function (user) {
                    console.log('logged in user:', user);
                    console.log(user.get('ethAddress'));
                })
                .catch(function (error) {
                    console.log(error);
                });
        }
    }

    async function logOut() {
        await Moralis.User.logOut();
        console.log('logged out');
    }

    return <div className={styles.container}>Mint Page</div>;
}
