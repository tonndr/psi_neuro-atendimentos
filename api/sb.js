// Proxy Supabase via Vercel: o navegador chama /api/sb?target=/rest/v1/...
// e a função repassa ao Supabase com Host/SNI corretos.
// Contorna DNS e filtros que bloqueiam *.supabase.co nos aparelhos.
const TARGET = 'https://vkehcheqkfnudjrvoot.supabase.co';

module.exports = async function handler(req, res) {
  try {
    const proto = req.headers['x-forwarded-proto'] || 'https';
    const url = new URL(req.url, proto + '://' + req.headers.host);
    const target = url.searchParams.get('target') || '/';
    const targetUrl = TARGET + target;

    const headers = {};
    Object.keys(req.headers || {}).forEach(function (k) {
      const lk = k.toLowerCase();
      if (lk === 'host' || lk === 'connection' || lk === 'content-length' || lk === 'accept-encoding') return;
      headers[k] = req.headers[k];
    });

    const hasBody = req.method !== 'GET' && req.method !== 'HEAD' && req.method !== 'OPTIONS';
    let body;
    if (hasBody) {
      body = (typeof req.body === 'string') ? req.body : JSON.stringify(req.body === undefined ? {} : req.body);
    }

    const upstream = await fetch(targetUrl, { method: req.method, headers: headers, body: body });
    const buf = Buffer.from(await upstream.arrayBuffer());
    res.statusCode = upstream.status;
    upstream.headers.forEach(function (v, k) {
      const lk = k.toLowerCase();
      if (lk === 'content-encoding' || lk === 'transfer-encoding' || lk === 'connection' || lk === 'content-length') return;
      res.setHeader(k, v);
    });
    res.end(buf);
  } catch (e) {
    res.statusCode = 502;
    res.setHeader('content-type', 'application/json');
    res.end(JSON.stringify({ error: 'proxy_error', message: String((e && e.message) || e) }));
  }
};
