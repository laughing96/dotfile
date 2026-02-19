import fitz  # PyMuPDF
import os
import sys


def export_highlights_context(pdf_path, output_dir, line_extend=5):
    """
    line_extend: 上下额外增加的行数
    """
    os.makedirs(output_dir, exist_ok=True)
    doc = fitz.open(pdf_path)
    md_file = os.path.join(output_dir, "highlights.md")

    with open(md_file, "w", encoding="utf-8") as md:
        md.write(f"# 高亮内容导出: {os.path.basename(pdf_path)}\n\n")

        for page_number in range(len(doc)):
            page = doc[page_number]
            page_rect = page.rect  # 页面全局矩形
            annotations = page.annots()
            if annotations is None:
                continue

            for idx, annot in enumerate(annotations):
                if annot.type[0] == 8:  # highlight
                    quad_points = annot.vertices
                    # 获取高亮的矩形范围
                    text_rects = []
                    for i in range(0, len(quad_points), 4):
                        quad = quad_points[i: i + 4]
                        rect = fitz.Quad(quad).rect
                        text_rects.append(rect)

                    # 合并矩形，得到整条高亮的最小矩形
                    rect_union = text_rects[0]
                    for r in text_rects[1:]:
                        rect_union |= r  # 并集

                    # 扩展高度
                    # 估算行高: rect_union.height / number_of_lines, 或固定值 12
                    extend_pix = line_extend * 12  # 可调整
                    new_rect = fitz.Rect(
                        page_rect.x0,  # 左对齐整页
                        max(rect_union.y0 - extend_pix, page_rect.y0),
                        page_rect.x1,  # 右对齐整页
                        min(rect_union.y1 + extend_pix, page_rect.y1),
                    )

                    # 提取文字
                    text = page.get_text("text", clip=new_rect).strip()

                    # 截图
                    pix = page.get_pixmap(clip=new_rect, alpha=False)
                    img_path = os.path.join(
                        output_dir, f"page{page_number+1}_highlight{idx+1}.png"
                    )
                    pix.save(img_path)

                    # 写入 Markdown
                    md.write(f"## 页面 {page_number+1} 高亮 {idx+1}\n\n")
                    md.write(f"{text}\n\n")
                    md.write(
                        f"![高亮截图](page{page_number+1}_highlight{idx+1}.png)\n\n"
                    )

    doc.close()
    print(f"导出完成！Markdown 文件: {md_file}")


if __name__ == "__main__":

    pdf_path = "ldd3.pdf"
    output_dir = "result"

    if not os.path.exists(pdf_path):
        print("PDF 文件不存在")
        sys.exit(1)

    export_highlights_context(pdf_path, output_dir)
