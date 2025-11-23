<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Giải K-Means</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  * { box-sizing: border-box; }
  
  body {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    background: #fafafa;
    color: #1a1a1a;
    line-height: 1.6;
  }
  
  header { 
    background: #fff; 
    border-bottom: 1px solid #e0e0e0;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  }
  
  .wrap { 
    max-width: 900px; 
    margin: 0 auto; 
    padding: 20px; 
  }
  
  nav { 
    display: flex; 
    gap: 24px;
    padding: 4px 0;
  }
  
  nav a { 
    color: #666; 
    text-decoration: none;
    padding: 8px 0;
    border-bottom: 2px solid transparent;
    transition: all 0.2s;
  }
  
  nav a:hover { 
    color: #333; 
  }
  
  nav a.active { 
    color: #333;
    font-weight: 500;
    border-bottom-color: #333;
  }
  
  h1 { 
    margin: 24px 0 20px 0; 
    font-size: 24px;
    font-weight: 600;
    color: #1a1a1a;
  }

  label { 
    display: block; 
    margin: 16px 0 8px; 
    font-weight: 500;
    font-size: 14px;
    color: #333;
  }
  
  .row { 
    display: flex; 
    gap: 16px; 
    flex-wrap: wrap; 
  }
  
  .row > div { 
    flex: 1 1 220px; 
  }
  
  input[type="number"], select {
    width: 100%;
    height: 42px;
    padding: 0 14px;
    border: 1px solid #d0d0d0;
    border-radius: 6px;
    background: #fff;
    font-size: 15px;
    transition: all 0.3s ease;
  }
  
  input[type="number"]:hover, select:hover {
    border-color: #999;
    transform: translateY(-1px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  }
  
  input[type="number"]:focus, select:focus {
    outline: none;
    border-color: #666;
    box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
    transform: translateY(0);
  }

  table { 
    width: 100%; 
    border-collapse: collapse;
    margin-top: 12px;
  }
  
  thead th {
    padding: 12px 10px;
    color: #666;
    font-weight: 500;
    font-size: 13px;
    text-align: left;
    border-bottom: 2px solid #e0e0e0;
    background: #fafafa;
  }
  
  tbody tr {
    border-bottom: 1px solid #f0f0f0;
  }
  
  tbody tr:hover {
    background: #fafafa;
  }
  
  tbody td {
    padding: 10px 8px;
  }

  table input[type="text"] {
    width: 100%;
    height: 38px;
    padding: 0 12px;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
    background: #fff;
    text-align: right;
    font-size: 14px;
    transition: border-color 0.2s;
  }
  
  table input[type="text"]::placeholder { 
    color: #aaa; 
  }
  
  table input[type="text"]:focus {
    outline: none;
    border-color: #999;
    background: #fff;
  }

  th.action, td.action { 
    width: 80px; 
    text-align: center; 
  }
  
  .btn-del {
    height: 34px;
    padding: 0 14px;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
    background: #fff;
    cursor: pointer;
    font-size: 13px;
    color: #666;
    transition: all 0.2s;
  }
  
  .btn-del:hover { 
    background: #f5f5f5;
    border-color: #ccc;
    color: #333;
  }

  .actions { 
    margin-top: 20px; 
    display: flex; 
    gap: 12px; 
    align-items: center; 
  }
  
  button {
    height: 42px;
    padding: 0 20px;
    border: 1px solid #d0d0d0;
    border-radius: 6px;
    background: #fff;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    color: #333;
    transition: all 0.2s;
  }
  
  button:hover { 
    background: #f5f5f5;
    border-color: #999;
  }
  
  button[type="submit"] {
    background: #333;
    color: #fff;
    border-color: #333;
  }
  
  button[type="submit"]:hover {
    background: #1a1a1a;
    border-color: #1a1a1a;
  }
  
  .hint { 
    color: #888; 
    font-size: 13px; 
    margin-top: 8px;
    font-style: italic;
  }
</style>
</head>
<body>
<header>
  <div class="wrap">
    <nav>
      <a class="active" href="<%= ctx %>/kmeans.jsp">Giải K-Means</a>
      <a href="<%= ctx %>/kmeans-image.jsp">Nén ảnh bằng K-Means</a>
    </nav>
  </div>
</header>

<main class="wrap">
  <h1>Giải K-Means</h1>

  <form id="fm" method="post" action="<%= ctx %>/kmeans/solve" accept-charset="UTF-8">
    <div class="row">
      <div>
        <label for="k">K</label>
        <input id="k" type="number" name="k" min="1" step="1" required>
      </div>
      <div>
        <label for="dims">Số chiều</label>
        <select id="dims" name="dims">
          <option value="2" selected>2</option>
          <option value="3">3</option>
        </select>
      </div>
    </div>

    <label>Nhập điểm dữ liệu</label>
    <table id="grid">
      <thead></thead>
      <tbody></tbody>
    </table>

    <div class="actions">
      <button type="button" id="addRow">Thêm dòng</button>
    </div>
    <div class="hint">Gõ số vào từng ô; khi gửi sẽ tự ghép thành định dạng x,y[,z].</div>

    <input type="hidden" id="points" name="points" value="">

    <div class="actions">
      <button type="submit">Gửi</button>
      <button type="reset" id="rs">Xóa</button>
    </div>
  </form>
</main>

<script>
  const dimsEl = document.getElementById('dims');
  const grid = document.getElementById('grid');
  const thead = grid.querySelector('thead');
  const tbody = grid.querySelector('tbody');
  const addRowBtn = document.getElementById('addRow');
  const pointsHidden = document.getElementById('points');
  const form = document.getElementById('fm');
  const rs = document.getElementById('rs');

  function currentDims() { return parseInt(dimsEl.value, 10); }

  function renderHead() {
    const d = currentDims();
    const tr = document.createElement('tr');
    for (let i = 1; i <= d; i++) {
      const th = document.createElement('th');
      th.textContent = 'x' + i;
      tr.appendChild(th);
    }
    const thAct = document.createElement('th');
    thAct.textContent = 'Xóa';
    thAct.className = 'action';
    tr.appendChild(thAct);
    thead.innerHTML = '';
    thead.appendChild(tr);
  }

  function makeInputCell() {
    const td = document.createElement('td');
    const inp = document.createElement('input');
    inp.type = 'text';
    inp.inputMode = 'decimal';
    inp.placeholder = '';
    td.appendChild(inp);
    return td;
  }

  function makeActionCell(tr) {
    const td = document.createElement('td');
    td.className = 'action';
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'btn-del';
    btn.textContent = 'Xóa';
    btn.addEventListener('click', () => tr.remove());
    td.appendChild(btn);
    return td;
  }

  function makeRow() {
    const d = currentDims();
    const tr = document.createElement('tr');
    for (let i = 0; i < d; i++) tr.appendChild(makeInputCell());
    tr.appendChild(makeActionCell(tr));
    return tr;
  }

  function addRow() { tbody.appendChild(makeRow()); }

  function adjustRowsOnDimsChange() {
    const d = currentDims();
    Array.from(tbody.rows).forEach(tr => {
      const inputs = tr.querySelectorAll('td input[type="text"]');
      const diff = d - inputs.length;
      if (diff > 0) {
        const actionCell = tr.lastElementChild;
        for (let i = 0; i < diff; i++) tr.insertBefore(makeInputCell(), actionCell);
      } else if (diff < 0) {
        for (let i = 0; i < -diff; i++) tr.removeChild(tr.children[tr.children.length - 2]);
      }
    });
  }

  function collectPoints() {
    const d = currentDims();
    const lines = [];
    Array.from(tbody.rows).forEach(tr => {
      const vals = Array.from(tr.querySelectorAll('td input[type="text"]'))
        .slice(0, d)
        .map(inp => (inp.value || '').trim().replace(',', '.'));
      if (vals.length === d && vals.every(v => v !== '')) lines.push(vals.join(','));
    });
    return lines.join('\n');
  }

  dimsEl.addEventListener('change', () => { renderHead(); adjustRowsOnDimsChange(); });
  addRowBtn.addEventListener('click', addRow);
  form.addEventListener('submit', () => { pointsHidden.value = collectPoints(); });
  rs.addEventListener('click', () => {
    setTimeout(() => { renderHead(); tbody.innerHTML=''; for (let i=0;i<5;i++) addRow(); }, 0);
  });

  renderHead(); for (let i=0;i<5;i++) addRow();
</script>
</body>
</html>