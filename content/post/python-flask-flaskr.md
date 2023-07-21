---
title: Flask 入门项目 Flaskr（一）
date: 2018-12-06 20:31:55
tags:
- Flask
- Python
categories:
- 后端
---

昨天看了看 flask ，感觉很有意思，于是上官网看看文档，文档的 quickly started 很精简，讲述了基本用法。在 1.0.2 的文档下有一个小项目，很适合拿来练手。于是尝试跟着写了一下。

<!--more-->

创建一个文件夹 flask-tutorial ，进入文件夹再创建文件夹 flaskr ，再进入 flaskr 创建一个 py 文件 __init__.py 。目前写到登录。文件内容如下：

``` python
import os
from flaskr.db import get_db


def create_app(test_config=None):
    # instance_relative_config: 项目开启依赖路径
    app = Flask(__name__, instance_relative_config=True)
    #  from_mapping 使用字典配置 app
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE=os.path.join(app.instance_path, 'flaskr.sqlite'),
    )

    if test_config is None:
        #  from_pyfile 使用 py 文件配置
        app.config.from_pyfile('config', silent=True)
    else:
        app.config.from_mapping(test_config)

    try:
        #  创建相应的文件夹
        os.makedirs(app.instance_path)
    except OSError:
        pass

    @app.route('/hello')
    def hello():
        return 'Hello, World!'

    from . import db, auth
    #  初始化数据库
    db.init_app(app)
    #  注册一个蓝图
    app.register_blueprint(auth.bp)
    return app
```

create_app 函数创建一个 app 。

创建 db.py 。我们使用 sqlite3 。

``` python

import sqlite3

import click
from flask import current_app, g

from flask.cli import with_appcontext


def get_db():
    if 'deb' not in g:
        #  g 是全局对象
        g.db = sqlite3.connect(
            current_app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
            #  detect_types 将数据库数据转换成相应类型
        )
        #  按行给处结果集
        g.db.row_factory = sqlite3.Row
    return g.db


def close_db(e=None):
    db=g.pop('db', None)
    if db is not None:
        if db is not None:
            db.close()

def init_db():
    db = get_db()
    with current_app.open_resource('schema.sql') as f:
        db.executescript(f.read().decode('utf8'))

# 创建一个命令行命令
# with_appcontext 代表获取上下文
@click.command('init-db')
@with_appcontext
def init_db_command():
    init_db()
    click.echo('Initialized the database.')

def init_app(app):
    app.teardown_appcontext(close_db) # 在请求发生之后执行
    app.cli.add_command(init_db_command) # 将命令注册到 flask-cli 上
```

创建 auth.py 。专门用来处理登录之类用户的事。内容如下：

``` python

import functools
from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash
from flaskr.db import get_db

bp = Blueprint('auth', __name__, url_prefix='/auth')
# 注册一个蓝图，前缀为 /auth

@bp.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        #  request.form 获取 request 中的表单对象
        username = request.form['username']
        password = request.form['password']
        db = get_db()
        error = None
        if not username:
            error = 'Username is required.'
        elif not password:
            error = 'Password is required.'
        elif db.execute(
            'SELECT * FROM user WHERE username = ?', (username, )
        ).fetchone() is not None:
            error = 'User {} is already registerd.'.format(username)

        if error is None:
            db.execute(
                'INSERT INTO user(username, password) VALUES (?,?)', (username,
                                                                      generate_password_hash(password))
                #  generate_password_hash 加盐 hash 加密
            )
            db.commit()
            return redirect(url_for('auth.login'))
        flash(error)
    return render_template('auth/register.html')


@bp.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        db = get_db()
        error = None
        user = db.execute(
            'SELECT * FROM user WHERE username = ?', (username,)
        ).fetchone()
        if user is None:
            error = 'Incorrect username.'
        elif not check_password_hash(user['password'], password): # check_password_hash 加盐 hash 解密
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['user_id'] = user['id']
            return redirect(url_for('index'))
        flash(error)
    return render_template('auth/login.html')


@bp.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')
    if user_id is None:
        g.user = None
    else:
        g.user = get_db().execute(
                'SELECT * FROM user WHERE id = ?', (user_id)
        ).fetchone()

@bp.route('/logout')
def logout():
    session.clear()
    #  url_for 构造一个 url 地址
    return redirect(url_for('index'))

# 这里未来可以做装饰器，这样用 @login_required
def login_required(view):
    #  装饰器
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for('auth.login'))
        return view(**kwargs)
    return wrapped_view
```

然后是 schema.sql 。

``` sql

DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS post;

CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL
);

CREATE TABLE post (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  author_id INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (author_id) REFERENCES user (id)
);
```

还有三个模板我就不写，自己看吧。[点此](https://dormousehole.readthedocs.io/en/latest/tutorial/templates.html)。
