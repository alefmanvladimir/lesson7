import { toNano } from 'ton-core';
import { TrackableCounter } from '../wrappers/TrackableCounter';
import { NetworkProvider } from '@ton-community/blueprint';

export async function run(provider: NetworkProvider) {
    const trackableCounter = provider.open(await TrackableCounter.fromInit(BigInt(Math.floor(Math.random() * 10000))));

    await trackableCounter.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(trackableCounter.address);

    console.log('ID', await trackableCounter.getId());
}
