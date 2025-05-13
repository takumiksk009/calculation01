// 料金プランごとの設定
const plans = {
    5: { base: 2150, tiers: [{ limit: 20, rate: 730 }, { limit: Infinity, rate: 680 }] },
    12: { base: 1400, tiers: [{ limit: 8, rate: 480 }, { limit: 30, rate: 430 }, { limit: Infinity, rate: 380 }] },
    13: { base: 1800, tiers: [{ limit: Infinity, rate: 590 }] },
    23: { base: 1900, tiers: [{ limit: 5, rate: 730 }, { limit: Infinity, rate: 540 }] },
    28: { base: 1900, tiers: [{ limit: 15, rate: 690 }, { limit: 30, rate: 670 }, { limit: Infinity, rate: 630 }] }
};

// 料金計算を行う関数
function calculateBill(planNumber, usage, days) {
    const plan = plans[planNumber];
    if (!plan) return null;

    const dailyBaseRate = plan.base / 30;
    const totalBaseRate = Math.ceil(dailyBaseRate * days);

    let consumptionRate = 0;
    let previousLimit = 0;
    let remainingUsage = usage;

    for (const tier of plan.tiers) {
        if (remainingUsage <= 0) break;
        const currentLimit = tier.limit;
        const tierRange = currentLimit - previousLimit;
        const tierUsage = Math.min(remainingUsage, tierRange);

        consumptionRate += tierUsage * tier.rate;
        remainingUsage -= tierUsage;
        previousLimit = currentLimit;
    }

    const subtotal = totalBaseRate + consumptionRate;
    const tax = Math.floor(subtotal * 0.1);
    const total = Math.floor(subtotal + tax);

    return {
        baseRate: totalBaseRate,
        consumptionRate: Math.round(consumptionRate),
        subtotal: Math.floor(subtotal),
        tax: tax,
        total: total
    };
}

// 検針日と指針から使用量と日数を計算
function calculateFromMeter() {
    const prevDate = new Date(document.getElementById('prevDate').value);
    const currDate = new Date(document.getElementById('currDate').value);
    const prevMeter = parseFloat(document.getElementById('prevMeter').value);
    const currMeter = parseFloat(document.getElementById('currMeter').value);

    if (isNaN(prevMeter) || isNaN(currMeter) || currMeter < prevMeter || isNaN(prevDate.getTime()) || isNaN(currDate.getTime())) {
        alert("正しい日付と指針を入力してください。");
        return;
    }

    const usage = parseFloat((currMeter - prevMeter).toFixed(2));
    const days = Math.max(1, Math.ceil((currDate - prevDate) / (1000 * 60 * 60 * 24)));

    document.getElementById('usage').value = usage;
    document.getElementById('days').value = days;
    document.getElementById('autoResult').textContent = `自動計算 → 使用量: ${usage}㎥ ／ 使用日数: ${days}日`;
}

// 計算を実行する関数
function performCalculation() {
    const planValue = document.getElementById('plan').value;
    if (!planValue) {
        alert("料金プランを選択してください。");
        return;
    }

    const planNumber = parseInt(planValue);
    const usage = parseFloat(document.getElementById('usage').value);
    const days = parseInt(document.getElementById('days').value);

    if (!plans[planNumber] || isNaN(usage) || usage < 0 || isNaN(days) || days <= 0) {
        alert("有効なプラン、使用量、使用日数を入力してください。\n（または自動入力をご利用ください）");
        return;
    }

    const result = calculateBill(planNumber, usage, days);

    document.getElementById('baseRate').textContent = `基本料金 = ¥${result.baseRate}`;
    document.getElementById('consumptionRate').textContent = `従量料金 = ¥${result.consumptionRate}`;
    document.getElementById('subtotal').textContent = `小計 = ¥${result.subtotal}`;
    document.getElementById('tax').textContent = `消費税 = ¥${result.tax}`;
    document.getElementById('total').textContent = `合計 = ¥${result.total}`;
}