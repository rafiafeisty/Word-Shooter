<div class="game-container">
  <h2>Game Preview</h2>
  
  <div class="difficulty-selector">
      <button class="difficulty-btn">Easy</button>
      <button class="difficulty-btn">Medium</button>
      <button class="difficulty-btn">Hard</button>
  </div>
  
  <div class="game-screen" id="gameScreen">
      <div class="word" style="top: 50px; left: 100px;">processor</div>
      <div class="word" style="top: 120px; left: 300px;">register</div>
      <div class="word" style="top: 200px; left: 200px;">interrupt</div>
  </div>
  
  <div class="stats">
      <div class="stat-box">
          <h3>Words Shot</h3>
          <p id="wordsShot">0</p>
      </div>
      <div class="stat-box">
          <h3>Accuracy</h3>
          <p id="accuracy">100%</p>
      </div>
      <div class="stat-box">
          <h3>Score</h3>
          <p id="score">0</p>
      </div>
  </div>
</div>

<div class="game-container">
  <h2>Game Features</h2>
  
  <ul class="feature-list">
      <li><strong>Low-Level Performance:</strong> Built entirely in MASM (Microsoft Macro Assembler) for maximum speed and efficiency</li>
      <li><strong>Dynamic Difficulty:</strong> Four levels that adjust word speed and complexity</li>
      <li><strong>Precision Scoring:</strong> Score calculated based on words hit, typing speed, and accuracy</li>
      <li><strong>Technical Vocabulary:</strong> Features words from computer science and assembly programming</li>
      <li><strong>Real-Time Feedback:</strong> Immediate scoring and performance statistics</li>
      <li><strong>Optimized Rendering:</strong> Direct hardware access for smooth animation</li>
  </ul>
  
  <h3>How It Works</h3>
  <p>
      Words fall from the top of the screen at varying speeds depending on difficulty.<br>
      Type the words correctly before they reach the bottom to score points.<br>
      The game uses direct keyboard interrupts for ultra-responsive input handling.
  </p>
</div>

<div class="game-container">
  <h2>Technical Implementation</h2>
  <p>
      This game leverages x86 assembly language features including:<br>
      - Direct hardware interrupts for input/output<br>
      - Precise timing using the processor's clock cycles<br>
      - Optimized string manipulation routines<br>
      - Memory-mapped display operations
  </p>
  <div class="masm-badge">COMING SOON: Download the .COM executable</div>
</div>

<script>
  // Simple animation for demonstration
  let words = document.querySelectorAll('.word');
  let positions = [
      {top: 50, left: 100},
      {top: 120, left: 300},
      {top: 200, left: 200}
  ];
  
  function animateWords() {
      positions.forEach((pos, i) => {
          pos.top += 1;
          if(pos.top > 300) pos.top = -30;
          words[i].style.top = pos.top + 'px';
          words[i].style.left = pos.left + 'px';
      });
      requestAnimationFrame(animateWords);
  }
  
  animateWords();
  
  // Simulate score updating
  setInterval(() => {
      document.getElementById('wordsShot').textContent = 
          parseInt(document.getElementById('wordsShot').textContent) + 1;
      document.getElementById('score').textContent = 
          parseInt(document.getElementById('score').textContent) + 10;
  }, 2000);
</script>
</body>
</html>
