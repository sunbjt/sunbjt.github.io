# sunbjt.github.io

克隆 next 主题

```
git clone https://github.com/theme-next/hexo-theme-next themes/next
```

next theme 的配置文件可以合并到主配置文件 `_config.yml` 中，细节见官方文档：https://theme-next.js.org/docs/getting-started/configuration

# 环境设置

markdown 需要用 pandoc 来渲染，卸载原始渲染引擎 renderer-marked 

```
brew install pandoc
npm un hexo-renderer-marked --save
npm i hexo-renderer-pandoc --save
```

增加 swig, rss-feed, math 的支持

```
npm install hexo-renderer-swig --save
npm install hexo-generator-feed --save
npm install hexo-math --save
```

增加站点地图，便于搜索引擎爬取

```
npm install hexo-generator-sitemap --save
```

支持 plantuml 流程图

```
npm install --save hexo-filter-plantuml
```

评论系统 

```
npm install hexo-next-giscus --save
```