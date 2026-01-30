import { tool } from "@opencode-ai/plugin"
import { promises as fs } from "fs"
import path from "path"

export default tool({
  description:
    "Initialize APM project directories for RAPID or DS. Creates directories only; does not create files.",
  args: {
    methodology: tool.schema
      .enum(["RAPID", "DS"])
      .describe("Project methodology: RAPID or DS"),
  },
  async execute({ methodology }, context) {
    const root = context.directory
    const dirs =
      methodology === "RAPID"
        ? ["src", "tests", "logs", "memory-bank"]
        : ["src", "experiments", "eda", "models", "logs", "memory-bank"]

    await Promise.all(
      dirs.map((dir) => fs.mkdir(path.join(root, dir), { recursive: true }))
    )

    return `Initialized directories in ${root}: ${dirs.join(", ")}`
  },
})
