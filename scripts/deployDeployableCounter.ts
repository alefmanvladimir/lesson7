import { toNano } from 'ton-core';
import { DeployableCounter } from '../wrappers/DeployableCounter';
import { NetworkProvider } from '@ton-community/blueprint';

export async function run(provider: NetworkProvider) {
    const deployableCounter = provider.open(await DeployableCounter.fromInit(BigInt(Math.floor(Math.random() * 10000))));

    await deployableCounter.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(deployableCounter.address);

    console.log('ID', await deployableCounter.getId());
}
