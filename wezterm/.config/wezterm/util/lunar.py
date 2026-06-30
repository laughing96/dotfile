from lunardate import LunarDate
import datetime


def days_since_chinese_new_year():
    today = datetime.date.today()

    lunar_today = LunarDate.fromSolarDate(today.year, today.month, today.day)
    lunar_year = lunar_today.year

    # 农历正月初一
    cny = LunarDate(lunar_year, 1, 1).toSolarDate()

    # 今天在春节之前 还没到今年春节
    if today < cny:
        lunar_year -= 1
        cny = LunarDate(lunar_year, 1, 1).toSolarDate()

    days = (today - cny).days
    all_days = 365
    left_days = all_days - days
    return left_days


if __name__ == "__main__":
    days = days_since_chinese_new_year()
    # 只输出过了多少天
    print(days, end="")
