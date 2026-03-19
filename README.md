8-Bit Assembly Memory Game


📌 Overview
Developed purely in 8-bit Assembly, this project is a highly optimized, fast-paced memory retention game. Built 3 years ago, it was designed as a deep dive into bare-metal programming, demonstrating direct hardware manipulation, strict memory management, and efficient CPU cycle utilization without the safety nets of modern high-level languages.

🎮 Gameplay Mechanics
The game tests the player's short-term memory and typing accuracy under pressure:

The Challenge: A dynamically generated sequence of characters (a long word) is flashed on the screen.

The Timer: The player has exactly 5 seconds to memorize the string before the screen is completely cleared.

The Recall: The player must manually type the exact sequence from memory.

🏆 The Streak Reward System: To keep the gameplay engaging, a progression system is implemented. For every 5 consecutive successful recalls, the game interrupts the standard flow to trigger a special Bonus Music Screen—a unique feature utilizing low-level audio generation.

⚙️ Technical Achievements & Architecture
While the game logic itself is straightforward, the true complexity lies in the underlying architecture and constraints of the 8-bit environment:

Aggressive Memory Optimization: Working within severe memory limitations, the code is meticulously structured to ensure a minimal memory footprint. Variables and states are tightly packed, and I placed a strong emphasis on proper memory cleanup to ensure absolute zero memory leaks during prolonged gameplay sessions.

Direct Register & I/O Manipulation: All input/output operations—from capturing keystrokes and rendering to the display, to managing the 5-second hardware timer—are handled directly via Assembly interrupts, bypassing standard OS abstractions.

Low-Level Audio Generation: The bonus music screen isn't just a UI element; it represents direct interaction with the system's audio hardware, manipulating frequencies and timing through Assembly instructions to produce sound.

State & Streak Management: Efficiently tracking the player's score and consecutive wins using minimal CPU cycles, seamlessly transitioning between the core game loop and the bonus states.

💡 Why Assembly?
Writing this in 8-bit Assembly was a deliberate choice to build a foundational understanding of computer architecture. It requires a profound respect for how memory is allocated, how registers operate, and how software interacts with hardware at the most granular level.
