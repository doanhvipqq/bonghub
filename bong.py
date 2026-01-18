# Konmeo22132?
import requests
import base64
import json
import re
import sys
import time
import uuid
import random
from urllib.parse import urlparse, urljoin
import os
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.align import Align
from rich.text import Text
from rich import box
from rich.console import Group
from rich.layout import Layout
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TimeRemainingColumn, track
from rich import print as rprint

# Force UTF-8 for Windows
if sys.platform == "win32":
    os.system("chcp 65001 > nul")
    sys.stdout.reconfigure(encoding='utf-8')

console = Console()

def clear_screen():
    console.clear()

def print_banner():
    # Cyberpunk Neon Banner
    title_text = Text(" ⚡ BONG X ⚡ ", style="bold bright_cyan on purple4")
    subtitle = Text("\nSYSTEM DECODE ACTIVATED\n", style="bold bright_magenta")
    contact = Text("TELEGRAM: @doanhvip12 | CHANNEL: @bongxtonghop_bot", style="italic spring_green1")
    
    panel = Panel(
        Align.center(title_text + subtitle + contact),
        border_style="bright_cyan",
        box=box.ROUNDED,
        padding=(1, 2),
        title="[bold bright_magenta]🔮 NEON EDITION 🔮[/]",
        subtitle="[bold bright_cyan]v3.0 ULTRA[/]"
    )
    console.print(panel)

# ================== HEADERS CHUNG ==================
HEADERS = {
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "accept": "*/*",
}

# ==================================================
# ================== BBMKTS ========================
# ==================================================
BASE_URL_BBMKTS = "https://bbmkts.com/00abx"

def get_domain(url: str) -> str:
    if not url.startswith(("http://", "https://")):
        url = "https://" + url
    return urlparse(url).netloc.replace("www.", "")

def get_code_bbmkts(target_url: str) -> str:
    domain = get_domain(target_url)
    headers = HEADERS.copy()
    headers["origin"] = f"https://{domain}"
    headers["referer"] = f"https://{domain}/"

    r = requests.get(
        BASE_URL_BBMKTS,
        params={"00xz": domain, "0012": target_url},
        headers=headers,
        timeout=15
    )

    data = r.json()
    token = data.get("token")
    if not token:
        raise Exception("Không có token")

    decoded = base64.b64decode(token).decode()
    code = json.loads(decoded).get("code")
    if not code:
        raise Exception("Không có code")

    return code

# ==================================================
# ================== YEULINK / XLINK ===================
# ==================================================

YEULINK_LIKE = {
    "yeulink": {
        "base": "https://yeulink.com",
        "domain": "yeulink.com"
    },
    "xlink": {
        "base": "https://xlink.co",
        "domain": "xlink.co"
    }
}

HEADERS_YEULINK = {
    "user-agent": "Mozilla/5.0",
    "content-type": "application/x-www-form-urlencoded"
}

def is_invalid_yeulink_like(url: str, domain: str) -> bool:
    return urlparse(url).netloc.lower().endswith(domain)

def get_yeulink_like_short_code(site_url: str, domain: str) -> str:
    if is_invalid_yeulink_like(site_url, domain):
        raise Exception("Không phải link get code")

    r = requests.get(site_url, timeout=15)

    pattern = rf'https://{re.escape(domain)}/site-[du]-v\d+\.js\?id=([A-Za-z0-9]+)'
    match = re.search(pattern, r.text)

    if not match:
        raise Exception("Website không hỗ trợ")

    return match.group(1)

def get_yeulink_like_code(base_url: str, short_code: str) -> str:
    s = requests.Session()
    s.headers.update(HEADERS_YEULINK)

    step = s.post(
        f"{base_url}/step",
        data={"code": short_code, "token": ""}
    ).json()

    if not step.get("success"):
        raise Exception("Không lấy được token")

    token = step.get("token", "")

    countdown = s.post(
        f"{base_url}/countdown",
        data={"code": short_code, "token": token}
    ).json()

    timer = countdown.get("timer", 0)
    console.print(f"[yellow]Đợi {timer}s...[/]")
    time.sleep(timer)

    final = s.post(
        f"{base_url}/continue",
        data={"code": short_code, "token": token}
    ).json()

    if final.get("code"):
        return final["code"]

    raise Exception("Không lấy được code")

# ==================================================
# ================== 4MMO ==========================
# ==================================================
BASE_URL_4MMO = "https://4mmo.net"

def get_4mmo_domain(url: str) -> str:
    if not url.startswith(("http://", "https://")):
        url = "http://" + url
    return urlparse(url).netloc.replace("www.", "")

def _extract_int_var(text: str, name: str, default: int) -> int:
    m = re.search(rf'{name}\s*=\s*(\d+);', text)
    return int(m.group(1)) if m else default

def get_4mmo_job():
    r = requests.get(f"{BASE_URL_4MMO}/4mmo", headers=HEADERS, timeout=15)
    if r.status_code != 200:
        raise Exception("Không load được 4mmo")

    match = re.search(
        r'jobtfs_4mmo_[A-Za-z0-9_]+\s*=\s*(\[[\s\S]*?\]);',
        r.text
    )
    if not match:
        raise Exception("Không tìm thấy job")

    job_data = json.loads(match.group(1))
    if not job_data:
        raise Exception("Hiện tại không có nhiệm vụ 4MMO (Hết job)")
    job = job_data[0]

    return {
        "link": job["link_url"],
        "id": job["id"],
        "traffic_ver2": job.get("traffic_ver2", 0),
        "traffic_time": _extract_int_var(r.text, "traffic_time", 60),
        "traffic2_time": _extract_int_var(r.text, "traffic2_time", 80),
        "traffic2_url_time": _extract_int_var(r.text, "traffic2_url_time", 15)
    }

def _run_4mmo_step(session, domain, job_id, wait_time):
    session.get(
        f"{BASE_URL_4MMO}/cd",
        params={"t": wait_time},
        timeout=15
    )

    console.print(f"[yellow]Đợi {wait_time}s...[/]")
    time.sleep(wait_time)

    return session.get(
        f"{BASE_URL_4MMO}/load_traffic",
        params={
            "r": "https://www.google.com/",
            "w": domain,
            "t": wait_time,
            "ti": job_id
        },
        timeout=15
    ).json()

def get_code_4mmo():
    job = get_4mmo_job()
    domain = get_4mmo_domain(job["link"])

    s = requests.Session()
    s.headers.update(HEADERS)
    s.headers["referer"] = "https://www.google.com/"

    console.print("[bold cyan]4MMO.NET[/]")
    console.print(f"[green]Lấy link thành công: {domain}[/]")

    if job["traffic_ver2"]:
        step_times = [
            job["traffic2_time"],
            job["traffic2_url_time"]
        ]
    else:
        step_times = [job["traffic_time"]]

    for idx, wait_time in enumerate(step_times, start=1):
        console.print(f"\n[bold magenta]STEP {idx}[/]")
        res = _run_4mmo_step(s, domain, job["id"], wait_time)

        if res.get("status") == 1:
            code = res.get("data", {}).get("html")
            if code:
                return code

        console.print("[italic]Chưa có code, tiếp tục step tiếp theo...[/]")

    raise Exception("Không lấy được code 4MMO")

# ==================================================
# ================== LINKTOT =======================
# ==================================================
BASE_URL_LINKTOT = "https://linktot.net"
LINKTOT_KEY = "2ThDrStTr"

HEADERS_LINKTOT_BACKLINK = {
    "User-Agent": "Mozilla/5.0",
    "Accept": "*/*",
    "Origin": "https://linktot.net",
}

HEADERS_LINKTOT_NORMAL = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Accept": "*/*",
    "Referer": "https://www.google.com/",
    "Origin": "https://www.google.com"
}

def xor_decrypt(encoded: str, key: str) -> str:
    raw = base64.b64decode(encoded)
    return "".join(
        chr(b ^ ord(key[i % len(key)]))
        for i, b in enumerate(raw)
    )

def get_code_linktot_backlink(target_url: str) -> str:
    if not target_url.startswith("http"):
        raise Exception("URL không hợp lệ")

    s = requests.Session()
    s.headers.update(HEADERS_LINKTOT_BACKLINK)

    rid = str(uuid.uuid4())

    ping = s.options(
        f"{BASE_URL_LINKTOT}/ping_backlink.php",
        headers={"rid": rid},
        timeout=15
    )

    cd = ping.headers.get("cd")
    if not cd:
        raise Exception("Không lấy được cd")

    console.print(f"[yellow]Đợi {cd}s...[/]")
    time.sleep(int(cd))

    payload = {
        "href": target_url,
        "hostname": "https://" + target_url.split("/")[2]
    }

    r = s.post(
        f"{BASE_URL_LINKTOT}/get-code.php",
        json=payload,
        headers={
            "rid": rid,
            "ref": target_url,
            "direct": "YES",
            "Content-Type": "application/json"
        },
        timeout=20
    )

    data = r.json()
    if "code" not in data:
        raise Exception(data)

    return xor_decrypt(data["code"], LINKTOT_KEY)

def get_code_linktot_normal(target_url: str) -> str:
    if not target_url.startswith("http"):
        raise Exception("URL không hợp lệ")

    s = requests.Session()
    s.headers.update(HEADERS_LINKTOT_NORMAL)

    rid = str(uuid.uuid4())

    ping = s.options(
        f"{BASE_URL_LINKTOT}/ping.php",
        headers={"rid": rid},
        timeout=15
    )

    cd = ping.headers.get("cd")
    if not cd:
        raise Exception("Không lấy được cd")

    console.print(f"[yellow]Đợi {cd}s...[/]")
    time.sleep(int(cd))

    payload = {
        "href": target_url,
        "hostname": "https://" + target_url.split("/")[2]
    }

    r = s.post(
        f"{BASE_URL_LINKTOT}/get-code.php",
        json=payload,
        headers={
            "rid": rid,
            "ref": target_url,
            "Content-Type": "application/json"
        },
        timeout=20
    )

    data = r.json()
    if "code" not in data:
        raise Exception(data)

    return xor_decrypt(data["code"], LINKTOT_KEY)

# ==================================================
# ========== LINKTOP.ONE / LINKNGON.IO / LINKNGON.ME =
# ==================================================

def normalize_https_url(url: str) -> str | None:
    url = url.strip()
    if not re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*://", url):
        url = "https://" + url

    parsed = urlparse(url)
    if parsed.scheme != "https" or not parsed.netloc:
        return None

    if not re.match(r"^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", parsed.netloc):
        return None

    return parsed._replace(fragment="").geturl()

def encode_p2p(url: str) -> str:
    if not isinstance(url, str) or not url:
        raise ValueError("encode_p2p(): URL None hoặc rỗng")
    return base64.b64encode(url.encode()).decode()

def extract_code(js: str):
    matches = re.findall(r"<strong[^>]*>([^<]+)</strong>", js)
    matches = [m.strip() for m in matches if m.strip() and not m.startswith("${")]
    return matches[-1] if matches else None

def extract_time_onsite(js: str) -> int:
    m = re.search(r"timeOnsite\s*=\s*(\d+)", js)
    return int(m.group(1)) if m else 0

def parse_steps(js: str):
    step = re.search(r"currentStep\s*=\s*(\d+)", js)
    total = re.search(r"numberOfSteps\s*=\s*(\d+)", js)
    return (
        int(step.group(1)) if step else None,
        int(total.group(1)) if total else None
    )

def get_internal_link(base_url: str) -> str | None:
    parsed = urlparse(base_url)
    base_host = parsed.netloc

    r = requests.get(base_url, headers=HEADERS, timeout=15)
    links = re.findall(r'href=["\'](.*?)["\']', r.text)

    for link in links:
        if link.startswith(("javascript:", "mailto:", "#")):
            continue
        if re.search(r"\.(jpg|png|css|js|svg|ico|pdf)$", link, re.I):
            continue

        full = urljoin(base_url, link)
        if urlparse(full).netloc == base_host and full != base_url:
            return full
    return None

def get_code_linktopngon(target_url: str, domain: str):
    js = requests.get(
        f"https://{domain}/v3/scripts/loaded.js",
        params={
            "p2p": encode_p2p(target_url),
            "v": random.random()
        },
        headers=HEADERS,
        timeout=15
    ).text

    step, total = parse_steps(js)

    if step == 0:
        return None, "Campaign không active (thử đổi nhiệm vụ khác)"

    if step == 1 and total == 1:
        return extract_code(js), None

    if step == 2 and total == 2:
        return extract_code(js), None

    if step == 1 and total == 2:
        wait = extract_time_onsite(js)
        if wait:
            console.print(f"[yellow]Đợi {wait}s...[/]")
            time.sleep(wait)

        next_link = get_internal_link(target_url)
        if not next_link:
            return None, "Không tìm thấy step 2"

        js2 = requests.get(
            f"https://{domain}/v3/scripts/loaded.js",
            params={
                "p2p": encode_p2p(next_link),
                "v": random.random()
            },
            headers=HEADERS,
            timeout=15
        ).text

        return extract_code(js2), None

    return None, "Không xác định trạng thái"

# ==================================================
# ========== KIEMTIENNGAY.COM ===========
# ==================================================
KIEMTIENNGAY_API_URL = "https://kiemtienngay.com/api/seo-token.php"

def _build_headers_kiemtienngay(page_url: str) -> dict:
    parsed = urlparse(page_url)
    origin = f"{parsed.scheme}://{parsed.netloc}"

    return {
        "User-Agent": "Mozilla/5.0",
        "Content-Type": "application/x-www-form-urlencoded",
        "Origin": origin,
        "Referer": page_url
    }

def get_code_kiemtienngay(page_url: str) -> str:
    headers = _build_headers_kiemtienngay(page_url)

    r = requests.post(
        KIEMTIENNGAY_API_URL,
        params={"action": "start"},
        headers=headers,
        data={"page_url": page_url},
        timeout=15
    )

    j = r.json()
    if not j.get("success"):
        raise Exception("Không lấy được token từ kiemtienngay")

    token = j.get("token")
    wait = int(j.get("wait", 0))

    if wait:
        console.print(f"[yellow]Đợi {wait}s...[/]")
        time.sleep(wait)

    r2 = requests.post(
        KIEMTIENNGAY_API_URL,
        params={"action": "get_code"},
        headers=headers,
        data={
            "token": token,
            "page_url": page_url
        },
        timeout=15
    )

    j2 = r2.json()
    if not j2.get("success") or "code_base64" not in j2:
        raise Exception("Không lấy được code từ kiemtienngay")

    return base64.b64decode(j2["code_base64"]).decode()

# ==================================================
# ========== NHAPMA.COM ============================
# ==================================================
BASE_API_NHAPMA = "https://service.nhapma.com"

BASE_HEADERS_NHAPMA = {
    "user-agent": "Mozilla/5.0",
    "content-type": "application/x-www-form-urlencoded",
    "accept": "*/*"
}

def _build_origin(url: str) -> str:
    p = urlparse(url)
    return f"{p.scheme}://{p.netloc}"

def _is_invalid_site_nhapma(url: str) -> bool:
    domain = urlparse(url).netloc.lower()
    return domain.endswith("nhapma.com")

def _get_short_code_nhapma(site_url: str) -> str:
    if _is_invalid_site_nhapma(site_url):
        raise Exception("Đây KHÔNG phải link lấy code (nhapma)")

    r = requests.get(site_url, timeout=15)
    if r.status_code != 200:
        raise Exception("Không truy cập được website")

    html = r.text

    match = re.search(
        r'/(?:user|direct)-vite-3\.js\?id=([A-Za-z0-9]+)',
        html
    )

    if not match:
        raise Exception("Website này không được hỗ trợ (nhapma)")

    return match.group(1)

def get_code_nhapma(site_url: str) -> str:
    short_code = _get_short_code_nhapma(site_url)
    origin = _build_origin(site_url)

    headers = BASE_HEADERS_NHAPMA.copy()
    headers.update({
        "origin": origin,
        "referer": site_url
    })

    s = requests.Session()
    s.headers.update(headers)

    # STEP
    step = s.post(
        f"{BASE_API_NHAPMA}/step",
        data={
            "code": short_code,
            "token": ""
        },
        timeout=15
    ).json()

    if not step.get("success"):
        raise Exception("Không lấy được token (nhapma)")

    token = step.get("token", "")

    # COUNTDOWN
    countdown = s.post(
        f"{BASE_API_NHAPMA}/countdown",
        data={
            "code": short_code,
            "token": token
        },
        timeout=15
    ).json()

    timer = countdown.get("timer", 0)
    console.print(f"[yellow]Đang xử lí, vui lòng đợi {timer}s...[/]")

    if timer > 10:
        time.sleep(timer - 10)
        console.print("[yellow]Còn 10s...[/]")
        time.sleep(10)
    else:
        time.sleep(timer)

    # CONTINUE
    final = s.post(
        f"{BASE_API_NHAPMA}/continue",
        data={
            "code": short_code,
            "token": token
        },
        timeout=15
    ).json()

    if final.get("code"):
        return final["code"]

    raise Exception("Không lấy được code cuối (nhapma)")

# ==================================================
# ================== MENU ==========================
# ==================================================
def pause():
    console.print(Panel("[bold bright_cyan]➤ Press ENTER to return to Main Menu...[/]", border_style="bright_magenta", box=box.ROUNDED))
    console.input()
    clear_screen()

def main():
    while True:
        clear_screen()
        print_banner()

        # Create Cyberpunk Table
        table = Table(
            show_header=True, 
            header_style="bold bright_white on purple4", 
            border_style="bright_cyan", 
            box=box.ROUNDED,
            expand=True,
            title="[bold spring_green1]>> AVAILABLE MODULES <<[/]",
            title_style="bold italic"
        )
        table.add_column("ID", justify="center", style="bold bright_magenta", width=4)
        table.add_column("MODULE NAME", style="bold bright_cyan", justify="left")
        table.add_column("STATUS", justify="center", style="bold spring_green1")

        services = [
            ("1", "� BBMKTS.COM", "ONLINE"),
            ("2", "� YEULINK.COM", "ONLINE"),
            ("3", "� XLINK.CO", "ONLINE"),
            ("4", "� 4MMO.NET", "ONLINE"),
            ("5", "� LINKTOT.NET", "ONLINE"),
            ("6", "� LINKTOP.ONE", "ONLINE"),
            ("7", "� LINKNGON.IO", "ONLINE"),
            ("8", "� LINKNGON.ME", "ONLINE"),
            ("9", "� KIEMTIENNGAY.COM", "ONLINE"),
            ("10", "� NHAPMA.COM", "ONLINE"),
        ]

        for stt, name, status in services:
            table.add_row(stt, name, f"⚡ {status}")

        console.print(table)
        
        # Footer Action
        console.print(Align.center("[bold grey50]Press 0 to Exit[/]"))
        
        c = console.input("\n[bold bright_white on bright_magenta] ➤ ENTER SELECTION (0-10): [/] ").strip()#:

        try:
            if c == "1":
                console.print(Panel("[bold bright_magenta]� BBMKTS.COM ACTIVATED[/]", border_style="bright_cyan"))
                link = console.input("[bold spring_green1]➤ INPUT LINK: [/]").strip()
                code = get_code_bbmkts(link)
                console.print(Panel(Align.center(f"[bold spring_green1]{code}[/]"), title="[bold bright_magenta]>> DECODE SUCCESS <<[/]", border_style="spring_green1", box=box.ROUNDED))
                pause()

            elif c == "2":
                console.print(Panel("[bold cyan]YEULINK.COM[/]", title="Selected"))
                link = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()

                cfg = YEULINK_LIKE["yeulink"]
                short = get_yeulink_like_short_code(link, cfg["domain"])
                code = get_yeulink_like_code(cfg["base"], short)
                console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                pause()

            elif c == "3":
                console.print(Panel("[bold cyan]XLINK.CO[/]", title="Selected"))
                link = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()

                cfg = YEULINK_LIKE["xlink"]
                short = get_yeulink_like_short_code(link, cfg["domain"])
                code = get_yeulink_like_code(cfg["base"], short)
                console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                pause()

            elif c == "4":
                code = get_code_4mmo()
                console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                pause()

            elif c == "5":
                while True:
                    console.print(Panel("[bold cyan]LINKTOT.NET[/]\n1. Backlink\n2. Normal\n0. Quay lại", title="Mode"))
                    t = console.input("[bold green]➤ Chọn (0-2): [/]").strip()

                    if t == "0":
                        break

                    if t not in ("1", "2"):
                        console.print("[bold red]Sai lựa chọn![/]")
                        continue

                    link = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()

                    code = ""
                    if t == "1":
                        code = get_code_linktot_backlink(link)
                    else:
                        code = get_code_linktot_normal(link)
                    
                    console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                    pause()
                    break

            elif c == "6":
                console.print(Panel("[bold cyan]LINKTOP.ONE[/]", title="Selected"))
                raw = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()
                link = normalize_https_url(raw)

                if not link:
                    console.print("[bold red]Link không hợp lệ (chỉ nhận https://domain)[/]")
                    pause()
                    continue

                code, err = get_code_linktopngon(link, "linktop.one")
                if code:
                    console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                else:
                    console.print(f"[bold red]❌ Lỗi: {err}[/]")
                pause()

            elif c == "7":
                console.print(Panel("[bold cyan]LINKNGON.IO[/]", title="Selected"))
                raw = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()
                link = normalize_https_url(raw)

                if not link:
                    console.print("[bold red]Link không hợp lệ (chỉ nhận https://domain)[/]")
                    pause()
                    continue

                code, err = get_code_linktopngon(link, "linkngon.io")
                if code:
                    console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                else:
                    console.print(f"[bold red]❌ Lỗi: {err}[/]")
                pause()

            elif c == "8":
                console.print(Panel("[bold cyan]LINKNGON.ME[/]", title="Selected"))
                raw = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()
                link = normalize_https_url(raw)

                if not link:
                    console.print("[bold red]Link không hợp lệ (chỉ nhận https://domain)[/]")
                    pause()
                    continue

                code, err = get_code_linktopngon(link, "linkngon.me")
                if code:
                    console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                else:
                    console.print(f"[bold red]❌ Lỗi: {err}[/]")
                pause()

            elif c == "9":
                console.print(Panel("[bold cyan]KIEMTIENNGAY.COM[/]", title="Selected"))
                raw = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()
                code = get_code_kiemtienngay(raw)
                console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                pause()

            elif c == "10":
                console.print(Panel("[bold cyan]NHAPMA.COM[/]", title="Selected"))
                raw = console.input("[bold green]➤ Nhập link lấy code: [/]").strip()
                code = get_code_nhapma(raw)
                console.print(Panel(f"[bold white]{code}[/]", title="[bold green]SUCCESS[/]", border_style="green"))
                pause()

            elif c == "0":
                console.print("[bold yellow]👋 Đã thoát chương trình.[/]")
                return

        except Exception as e:
            console.print(f"[bold red]❌ Lỗi: {e}[/]")
            pause()

if __name__ == "__main__":
    main()