import { toNano } from 'ton-core';
import { StoppableCounter } from '../wrappers/StoppableCounter';
import { NetworkProvider } from '@ton-community/blueprint';

export async function run(provider: NetworkProvider) {
    const stoppableCounter = provider.open(await StoppableCounter.fromInit(BigInt(Math.floor(Math.random() * 10000))));

    await stoppableCounter.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(stoppableCounter.address);

    console.log('ID', await stoppableCounter.getId());
}
