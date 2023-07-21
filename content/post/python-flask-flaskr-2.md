---
title: Flask 入门项目 Flaskr（二）
date: 2018-12-07 20:47:45
tags:
- Python
- Flask
categories:
- 后端 
---

今天身体不太舒服，感冒了。不过还是照着官网大概打了一下。这个项目的主体是完成了，改天写写测试。

<!--more-->

修改一下 __init__.py 。

``` python

import os
from flask import Flask


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

    from . import db, auth, blog
    #  初始化数据库
    db.init_app(app)
    #  注册一个蓝图
    app.register_blueprint(auth.bp)
    app.register_blueprint(blog.bp)
    #  添加路由，添加了 index 为 '/' ，一般来说，endpoint 等于视图函数名字，url_for 是通过 endpoint 来访问对应的 url 的。
    app.add_url_rule('/', endpoint='index')
    return app
```

然后 blog.py 是主体。

``` python

from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for
)
from werkzeug.exceptions import abort
from flaskr.auth import login_required
from flaskr.db import get_db

bp = Blueprint('blog', __name__)


@bp.route('/')
def index():
    db = get_db()
    posts = db.execute(
        'SELECT p.id, title, body, created, author_id, username'
        ' FROM post p JOIN user u ON p.author_id = u.id ORDER BY created DESC'
    ).fetchall()
    return render_template('blog/index.html', posts=posts)


@bp.route('/create', methods=('GET', 'POST'))
@login_required
def create():
    if request.method == 'POST':
        title = request.form['title']
        body = request.form['body']
        error = None
        if not title:
            error = 'Title is required.'
        if error is not None:
            flash(error)
        else:
            db = get_db()
            db.execute(
                'INSERT INTO post (title, body, author_id)'
                ' VALUES (?, ?, ?)',
                (title, body, g.user['id'])
            )
            db.commit()
            return redirect(url_for('blog.index'))
    return render_template('blog/create.html')


# check_author 函数可用于在不检查作者的情况下获取一个 post 。
# 这里获取某一帖子，左外连接是将用户名和作者联系起来
def get_post(id,  check_author=True):
    post = get_db().execute(
        'SELECT p.id, title, body, created, author_id, username'
        ' FROM post p JOIN user u ON p.author_id = u.id'
        ' WHERE p.id = ?',
        (id,)
    ).fetchone()
    if post is None:
        abort(404, "Post id {0} doesnt't exist".format(id))
    if check_author and post['author_id'] != g.user['id']:
        abort(403)

    return post

@bp.route('/<int:id>/update', methods=('GET', 'POST'))
@login_required
def update(id):
    post = get_post(id)
    if request.method == 'POST':
        title = request.form['title']
        body = request.form['body']
        error = None
        if not title:
            error = 'Title is required.'
        if error is not None:
            flash(error)
        else:
            db = get_db()
            db.execute('UPDATE post SET title = ?, body = ?'
            'WHERE id=?', (title, body, id))
            db.commit()
            return redirect(url_for('blog.index'))
    return render_template('blog/update.html', post = post)

@bp.route('/<int:id>/delete', methods=('POST',))
@login_required
def delete(id):
    get_post(id)
    db = get_db()
    db.execute('DELETE FROM post WHERE id = ?', (id, ))
    return redirect(url_for('blog.index'))
```

然后原来的 auth.py 有个地方写错了。更正一下。

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
        # check_password_hash 加盐 hash 解密
        elif not check_password_hash(user['password'], password):
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
            'SELECT * FROM user WHERE id = ?', (user_id,)
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

还一些模板，不写了，难受。
