const fs = require('fs');
const engineCode = fs.readFileSync('scratch/chat_engine.js', 'utf8');

const fullScript = `
${engineCode}

class DCLogic {}

class Component extends DCLogic {
  state = {
    activeMenu: null,
    scrolled: false,
    searchOpen: false,
    mobileOpen: false,
    mobileAccordion: null
  };

  componentDidMount() {
    this.initChatEngine();
  }

  initChatEngine = () => {
    console.log('initChatEngine successfully defined');
  };
}

const c = new Component();
c.componentDidMount();
console.log('All syntax checks passed 100%!');
`;

new Function(fullScript)();
