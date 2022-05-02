const { task } = require('hardhat/config')

task('newVoting', 'Add new voting')
  .addParam('candidatsArr', 'Array of all candidates adresses')
  .setAction(async (taskArgs) => {
    const Voting = await ethers.getContractFactory('Vote')
    await Voting.addVoting(taskArgs.candidateAddress)
    console.log(`New voting created # ${Voting.votingId}`)
  })
