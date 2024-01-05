import fs from "fs";

export async function sleep(seconds: number) {
  new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}

export const loadWallet = (file: string) => {
  return JSON.parse(fs.readFileSync(file).toString()) as number[];
};
