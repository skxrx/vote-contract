const hardhat = require('hardhat')

async function main() {
  const Voting = await await hardhat.ethers.getContractFactory('Vote')
  const voting = await Voting.deploy()

  await voting.deployed()

  console.log('Voting deployed to:', voting.address)
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
