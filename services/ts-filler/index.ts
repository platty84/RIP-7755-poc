import { sleep } from "bun";

import { SupportedChains } from "./src/types/chain";
import IndexerService from "./src/indexer/indexer.service";

async function main() {
  const sourceChain = SupportedChains.ArbitrumSepolia;
  const indexerService = new IndexerService();
  let success = false,
    startingBlock = 0;

  while (true) {
    try {
      startingBlock = await indexerService.poll(sourceChain, startingBlock);
      success = true;
    } catch (e) {
      console.error(e);

      if (!success) {
        console.error("First process failed - exiting...");
        break;
      }
    } finally {
      await sleep(3000);
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
