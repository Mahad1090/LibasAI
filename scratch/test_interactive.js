const { spawn } = require('child_process');
const http = require('http');
const fs = require('fs');

const edge = spawn('C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe', [
  '--headless=new',
  '--remote-debugging-port=9225',
  '--window-size=1440,900',
  '--disable-gpu',
  'http://localhost:3000/Ai%20Assistant.dc.html'
]);

setTimeout(async () => {
  try {
    const list = await new Promise((res, rej) => {
      http.get('http://localhost:9225/json', r => {
        let d = ''; r.on('data', c => d += c); r.on('end', () => res(JSON.parse(d)));
      }).on('error', rej);
    });
    const target = list.find(p => p.url.includes('Ai%20Assistant'));
    if (!target) throw new Error('Target not found');

    const ws = new WebSocket(target.webSocketDebuggerUrl);
    await new Promise(r => ws.onopen = r);

    let id = 1;
    function send(method, params = {}) {
      return new Promise((resolve) => {
        const curId = id++;
        const handler = (evt) => {
          const msg = JSON.parse(evt.data);
          if (msg.id === curId) {
            ws.removeEventListener('message', handler);
            resolve(msg.result);
          }
        };
        ws.addEventListener('message', handler);
        ws.send(JSON.stringify({ id: curId, method, params }));
      });
    }

    // Wait for images to load
    await new Promise(r => setTimeout(r, 3500));

    // 1. Capture initial conversation state with images loaded
    let shot = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync('c:\\Users\\waree\\Desktop\\LibasAI\\test_state_1_initial.png', Buffer.from(shot.data, 'base64'));
    console.log('Saved test_state_1_initial.png');

    // 2. Click "Eid outfit ideas" in the left sidebar
    await send('Runtime.evaluate', {
      expression: `(() => {
        const btn = document.querySelector('[data-conv-id="eid-outfit"]');
        if (btn) btn.click();
        return !!btn;
      })()`
    });
    await new Promise(r => setTimeout(r, 1000));
    shot = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync('c:\\Users\\waree\\Desktop\\LibasAI\\test_state_2_eid_switch.png', Buffer.from(shot.data, 'base64'));
    console.log('Saved test_state_2_eid_switch.png');

    // 3. Test dynamic search: type "black kurta for men under 8000" and submit
    await send('Runtime.evaluate', {
      expression: `(() => {
        const input = document.getElementById('lb-chat-input');
        const form = document.getElementById('lb-chat-form');
        if (input && form) {
          input.value = 'black kurta for men under 8000';
          form.dispatchEvent(new Event('submit', { cancelable: true }));
          return true;
        }
        return false;
      })()`
    });

    // Wait for simulated search latency (550ms) + rendering
    await new Promise(r => setTimeout(r, 2000));
    shot = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync('c:\\Users\\waree\\Desktop\\LibasAI\\test_state_3_search_result.png', Buffer.from(shot.data, 'base64'));
    console.log('Saved test_state_3_search_result.png');

    ws.close();
    edge.kill();
  } catch(e) {
    console.error('Interactive test error:', e);
    edge.kill();
  }
}, 3000);
